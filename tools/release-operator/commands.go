package main

import (
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/Obedience-Corp/festival/tools/release-operator/internal/operator"
)

const festivalRepoSlug = "Obedience-Corp/festival"

var submodules = []string{"fest", "camp"}

// ghClient abstracts the GitHub CLI operations the ship-via-PR path needs so
// the PR create/merge flow can be exercised in tests without hitting GitHub.
type ghClient interface {
	authenticated() bool
	viewerCanMerge(repo string) (bool, error)
	openPullRequestNumber(repo, branch string) (string, error)
	createPullRequest(repo, base, head, title, body string) error
	mergePullRequest(repo, branch string) error
}

type repoContext struct {
	Root string
	// gh overrides the GitHub CLI seam in tests; nil means shell out to gh.
	gh ghClient
}

func newRepoContext(root string) (*repoContext, error) {
	absRoot, err := filepath.Abs(root)
	if err != nil {
		return nil, fmt.Errorf("resolve repo root: %w", err)
	}
	return &repoContext{Root: absRoot}, nil
}

func (r *repoContext) ghClient() ghClient {
	if r.gh != nil {
		return r.gh
	}
	return cliGH{dir: r.Root}
}

// cliGH is the production ghClient backed by the gh binary.
type cliGH struct {
	dir string
}

func (g cliGH) authenticated() bool {
	return ghAuthenticated()
}

func (g cliGH) viewerCanMerge(repo string) (bool, error) {
	out, err := cmdOutput(g.dir, nil, "gh", "api", "repos/"+repo, "--jq", ".permissions.push")
	if err != nil {
		return false, fmt.Errorf("check push permission on %s: %w", repo, err)
	}
	return strings.TrimSpace(out) == "true", nil
}

// openPullRequestNumber returns the number of an open PR for branch, or "" when
// none is open. Unlike `gh pr view`, `gh pr list` exits 0 with an empty array
// for the no-PR case, so a non-nil error here is a real gh/network failure and
// must not be mistaken for "no PR".
func (g cliGH) openPullRequestNumber(repo, branch string) (string, error) {
	out, err := cmdOutput(g.dir, nil, "gh", "pr", "list", "--repo", repo, "--head", branch, "--state", "open", "--json", "number", "--jq", ".[0].number // \"\"")
	if err != nil {
		return "", fmt.Errorf("query open PR for %s: %w", branch, err)
	}
	return strings.TrimSpace(out), nil
}

func (g cliGH) createPullRequest(repo, base, head, title, body string) error {
	return runCmd(g.dir, nil, "gh", "pr", "create", "--repo", repo, "--base", base, "--head", head, "--title", title, "--body", body)
}

func (g cliGH) mergePullRequest(repo, branch string) error {
	return runCmd(g.dir, nil, "gh", "pr", "merge", branch, "--repo", repo, "--squash", "--delete-branch")
}

func (r *repoContext) submodulePath(name string) string {
	return filepath.Join(r.Root, name)
}

func (r *repoContext) git(args ...string) (string, error) {
	return gitOutput(r.Root, args...)
}

func (r *repoContext) gitSubmodule(name string, args ...string) (string, error) {
	return gitOutput(r.submodulePath(name), args...)
}

func (r *repoContext) runGit(args ...string) error {
	return runCmd(r.Root, nil, "git", args...)
}

func (r *repoContext) runGitSubmodule(name string, args ...string) error {
	return runCmd(r.submodulePath(name), nil, "git", args...)
}

func (r *repoContext) just(args ...string) error {
	return runCmd(r.Root, nil, "just", args...)
}

func (r *repoContext) justEnv(env map[string]string, args ...string) error {
	return runCmd(r.Root, env, "just", args...)
}

func (r *repoContext) ensureAllWorktreesClean() error {
	dirty, err := worktreeDirty(r.Root)
	if err != nil {
		return err
	}
	if dirty {
		return errors.New("festival repo has uncommitted changes")
	}

	for _, sub := range submodules {
		dirty, err := worktreeDirty(r.submodulePath(sub))
		if err != nil {
			return err
		}
		if dirty {
			return fmt.Errorf("%s has uncommitted changes", sub)
		}
	}

	return nil
}

func (r *repoContext) fetchReleaseRefs() error {
	if err := runCmd(r.Root, nil, "git", "fetch", "--prune", "--prune-tags", "origin", "+refs/tags/*:refs/tags/*", "+refs/heads/main:refs/remotes/origin/main"); err != nil {
		return err
	}
	for _, sub := range submodules {
		if err := runCmd(r.submodulePath(sub), nil, "git", "fetch", "--prune", "--prune-tags", "origin", "+refs/tags/*:refs/tags/*"); err != nil {
			return err
		}
	}
	return nil
}

func (r *repoContext) stageReleaseArtifacts() error {
	return r.runGit("add", "fest", "camp", "docs/cli-reference")
}

func (r *repoContext) stageSubmoduleRefs() error {
	return r.runGit("add", "fest", "camp")
}

func (r *repoContext) runDocs(mode releaseMode) error {
	return r.justEnv(mode.DocsEnv, "docs", "all")
}

func (r *repoContext) checkBundledModuleResolution(name string) error {
	tag, err := r.exactTag(name)
	if err != nil {
		return err
	}
	if tag == "" {
		tag = "HEAD"
	}

	modCacheDir, err := os.MkdirTemp("", "festival-"+name+"-gomodcache-")
	if err != nil {
		return fmt.Errorf("create %s module cache: %w", name, err)
	}
	defer os.RemoveAll(modCacheDir)

	goCacheDir, err := os.MkdirTemp("", "festival-"+name+"-gocache-")
	if err != nil {
		return fmt.Errorf("create %s build cache: %w", name, err)
	}
	defer os.RemoveAll(goCacheDir)

	env := map[string]string{
		"GOWORK":     "off",
		"GOMODCACHE": modCacheDir,
		"GOCACHE":    goCacheDir,
	}
	if _, err := cmdOutput(r.submodulePath(name), env, "go", "mod", "download"); err != nil {
		return fmt.Errorf("%s %s module graph does not resolve from a clean cache: %w", name, tag, err)
	}

	return nil
}

func (r *repoContext) exactTag(name string) (string, error) {
	return exactTagAt(r.submodulePath(name))
}

func (r *repoContext) exactComponentTags(modeName string) (string, string, error) {
	festTag, err := exactTagAtForMode(r.submodulePath("fest"), modeName)
	if err != nil {
		return "", "", err
	}
	campTag, err := exactTagAtForMode(r.submodulePath("camp"), modeName)
	if err != nil {
		return "", "", err
	}
	if festTag == "" || campTag == "" {
		return "", "", errors.New("submodules are not pinned to exact tags")
	}
	return festTag, campTag, nil
}

func (r *repoContext) cachedDiffExists(paths ...string) (bool, error) {
	args := []string{"diff", "--cached", "--quiet", "--"}
	args = append(args, paths...)
	cmd := exec.Command("git", args...)
	cmd.Dir = r.Root
	if err := cmd.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 1 {
			return true, nil
		}
		return false, fmt.Errorf("git %s: %w", strings.Join(args, " "), err)
	}
	return false, nil
}

func releaseCommitMessage(currentFestTag, currentCampTag, festTag, campTag string) string {
	festChanged := currentFestTag != festTag
	campChanged := currentCampTag != campTag

	switch {
	case festChanged && campChanged:
		return fmt.Sprintf("Release: pin fest %s and camp %s", festTag, campTag)
	case festChanged:
		return fmt.Sprintf("Release: pin fest %s", festTag)
	case campChanged:
		return fmt.Sprintf("Release: pin camp %s", campTag)
	default:
		return fmt.Sprintf("Release: refresh bundled docs for fest %s and camp %s", festTag, campTag)
	}
}

const shipBranchPrefix = "release-pin/"

func shipBranchName(releaseTag string) string {
	return shipBranchPrefix + releaseTag
}

func shipsViaPullRequest(branch string) bool {
	return branch == "main"
}

func releasePRBody(releaseTag, message string) string {
	return fmt.Sprintf("%s.\n\nCreated by the release operator: main only accepts changes through pull requests, so the pin commit ships through this PR. After the squash merge, the operator tags %s on main to trigger release CI.", message, releaseTag)
}

func (r *repoContext) currentBranch() (string, error) {
	return r.git("rev-parse", "--abbrev-ref", "HEAD")
}

func (r *repoContext) shipPinnedArtifacts(releaseTag, currentFestTag, currentCampTag, festTag, campTag string) error {
	hasDiff, err := r.cachedDiffExists("fest", "camp", "docs/cli-reference")
	if err != nil {
		return err
	}
	if !hasDiff {
		fmt.Printf("Submodule pointers and docs already at fest=%s, camp=%s; no release commit needed.\n", festTag, campTag)
		return nil
	}

	branch, err := r.currentBranch()
	if err != nil {
		return err
	}
	message := releaseCommitMessage(currentFestTag, currentCampTag, festTag, campTag)
	if !shipsViaPullRequest(branch) {
		if err := r.runGit("commit", "-m", message); err != nil {
			return err
		}
		return r.runGit("push", "origin", "HEAD")
	}
	return r.shipViaPullRequest(branch, releaseTag, message)
}

func (r *repoContext) shipViaPullRequest(baseBranch, releaseTag, message string) error {
	gh := r.ghClient()
	if !gh.authenticated() {
		return fmt.Errorf("%s only accepts changes through pull requests and gh is not authenticated; run 'gh auth login' and retry", baseBranch)
	}
	// Verify the merge is possible before mutating anything, so a permission
	// gap fails fast instead of after the branch and PR already exist.
	canMerge, err := gh.viewerCanMerge(festivalRepoSlug)
	if err != nil {
		return err
	}
	if !canMerge {
		return fmt.Errorf("the authenticated gh account lacks push permission on %s and cannot merge the release PR; switch to an account with write access (gh auth switch) and retry", festivalRepoSlug)
	}

	shipBranch := shipBranchName(releaseTag)
	if err := r.runGit("switch", "-C", shipBranch); err != nil {
		return err
	}
	if err := r.runGit("commit", "-m", message); err != nil {
		return err
	}
	if err := r.runGit("push", "-f", "-u", "origin", shipBranch); err != nil {
		return err
	}

	open, err := gh.openPullRequestNumber(festivalRepoSlug, shipBranch)
	if err != nil {
		return err
	}
	if open == "" {
		if err := gh.createPullRequest(festivalRepoSlug, baseBranch, shipBranch, message, releasePRBody(releaseTag, message)); err != nil {
			return err
		}
	}
	if err := gh.mergePullRequest(festivalRepoSlug, shipBranch); err != nil {
		return fmt.Errorf("merge release PR for %s: %w\nThe pin commit is pushed and the PR exists; check the PR for unmet merge requirements (required approvals or status checks), merge it on GitHub, then rerun the same release command to continue tagging", shipBranch, err)
	}

	if err := r.runGit("switch", baseBranch); err != nil {
		return err
	}
	if _, err := r.git("rev-parse", "--verify", "refs/heads/"+shipBranch); err == nil {
		if err := r.runGit("branch", "-D", shipBranch); err != nil {
			return err
		}
	}
	if err := r.runGit("pull", "--ff-only", "origin", baseBranch); err != nil {
		return err
	}
	if err := r.runGit("submodule", "update", "--init"); err != nil {
		return err
	}
	dirty, err := worktreeDirty(r.Root)
	if err != nil {
		return err
	}
	if dirty {
		return fmt.Errorf("festival repo is dirty after merging %s; resolve manually before tagging", shipBranch)
	}
	return nil
}

func (r *repoContext) prepareMainForBundle() error {
	branch, err := r.currentBranch()
	if err != nil {
		return err
	}
	if strings.HasPrefix(branch, shipBranchPrefix) {
		if err := r.runGit("switch", "main"); err != nil {
			return err
		}
		if err := r.runGit("branch", "-D", branch); err != nil {
			return err
		}
		branch = "main"
	}
	if branch != "main" {
		return nil
	}
	if dirty, err := worktreeDirty(r.Root); err != nil {
		return err
	} else if dirty {
		return errors.New("festival repo has uncommitted changes")
	}
	if err := r.runGit("pull", "--ff-only", "origin", "main"); err != nil {
		return err
	}
	return r.runGit("submodule", "update", "--init")
}

func (r *repoContext) ensureTagAbsent(tag string) error {
	if _, err := r.git("rev-parse", "-q", "--verify", "refs/tags/"+tag); err == nil {
		return fmt.Errorf("festival tag %s already exists locally", tag)
	}
	remote, err := r.git("ls-remote", "--tags", "origin", "refs/tags/"+tag)
	if err != nil {
		return err
	}
	if strings.TrimSpace(remote) != "" {
		return fmt.Errorf("festival tag %s already exists on origin", tag)
	}
	return nil
}

func (r *repoContext) ensureSubmoduleTagAbsent(name, tag string) error {
	if _, err := r.gitSubmodule(name, "rev-parse", "-q", "--verify", "refs/tags/"+tag); err == nil {
		return fmt.Errorf("%s tag %s already exists locally", name, tag)
	}
	remote, err := r.gitSubmodule(name, "ls-remote", "--tags", "origin", "refs/tags/"+tag)
	if err != nil {
		return err
	}
	if strings.TrimSpace(remote) != "" {
		return fmt.Errorf("%s tag %s already exists on origin", name, tag)
	}
	return nil
}

func (r *repoContext) createAndPushFestivalTag(tag string, annotation string) error {
	if err := r.runGit("tag", "-a", tag, "-m", annotation); err != nil {
		return err
	}
	return r.runGit("push", "origin", tag)
}

func (r *repoContext) createAndPushSubmoduleTag(name, tag string) error {
	if err := r.runGitSubmodule(name, "tag", "-a", tag, "-m", "Release "+tag); err != nil {
		return err
	}
	return r.runGitSubmodule(name, "push", "origin", tag)
}

func (r *repoContext) checkoutSubmoduleTag(name, tag string) error {
	return r.runGitSubmodule(name, "checkout", "--detach", tag)
}

// submoduleIsIndependent reports whether dir is itself a distinct git
// worktree rather than an uninitialized submodule placeholder directory.
// Git commands locate their repository by walking up from cwd through
// parent directories until they find a .git entry. An uninitialized
// submodule directory has none of its own, so every git command run
// against it silently resolves against the superproject instead of
// failing. That fallthrough is what let the pin flow resolve the
// superproject's own ancient tags for camp/fest, and what turned a
// submodule "checkout" into a checkout of the superproject itself.
// Comparing the discovered toplevel against dir catches that fallthrough
// directly, regardless of why the submodule ended up uninitialized.
func submoduleIsIndependent(dir string) bool {
	info, statErr := os.Stat(dir)
	if statErr != nil || !info.IsDir() {
		return false
	}
	out, err := gitOutput(dir, "rev-parse", "--show-toplevel")
	if err != nil {
		return false
	}
	want := cleanRealPath(dir)
	got := cleanRealPath(strings.TrimSpace(out))
	return want != "" && want == got
}

// cleanRealPath resolves path to an absolute, symlink-free form for
// worktree-identity comparisons, falling back to the plain absolute path
// when symlink resolution fails (e.g. the path does not exist yet).
func cleanRealPath(path string) string {
	abs, err := filepath.Abs(path)
	if err != nil {
		return ""
	}
	if real, err := filepath.EvalSymlinks(abs); err == nil {
		return real
	}
	return abs
}

// ensureSubmodulesReady verifies every submodule under root is its own
// independent git worktree before any release tooling reads or mutates it.
// When a submodule is not initialized, it is initialized automatically
// (git submodule update --init) and its tags are fetched; if it still is
// not independent afterward, ensureSubmodulesReady refuses loudly before
// any further mutation happens rather than let git silently fall through
// to the superproject. See festival-release-operator-running-pin-20260729-233926.
func ensureSubmodulesReady(root string) error {
	for _, sub := range submodules {
		path := filepath.Join(root, sub)
		if submoduleIsIndependent(path) {
			continue
		}

		fmt.Printf("%s submodule is not initialized; running 'git submodule update --init -- %s'\n", sub, sub)
		if err := runCmd(root, nil, "git", "submodule", "update", "--init", "--", sub); err != nil {
			return fmt.Errorf("initialize %s submodule: %w\nrun 'git submodule update --init -- %s' in %s and retry", sub, err, sub, root)
		}
		if !submoduleIsIndependent(path) {
			return fmt.Errorf("%s did not become an independent git worktree after 'git submodule update --init'; refusing to continue rather than risk resolving refs against the superproject", sub)
		}

		if err := runCmd(path, nil, "git", "fetch", "--prune", "--prune-tags", "origin", "+refs/tags/*:refs/tags/*"); err != nil {
			return fmt.Errorf("fetch tags for %s after initializing submodule: %w", sub, err)
		}
		fmt.Printf("%s submodule initialized and tags fetched\n", sub)
	}
	return nil
}

// verifyCheckedOutTag confirms dir's HEAD is exactly the tag that was just
// requested, rather than trusting the checkout succeeded silently against
// the wrong repository or an unrelated commit.
func verifyCheckedOutTag(dir, name, tag string) error {
	got, err := exactTagAt(dir)
	if err != nil {
		return fmt.Errorf("verify %s checkout: %w", name, err)
	}
	if got != tag {
		return fmt.Errorf("%s HEAD resolved to tag %q after checking out %q; refusing to trust a mismatched pin", name, valueOrNone(got), tag)
	}
	return nil
}

// gitRef captures a worktree's exact position: the branch it was on (empty
// when HEAD was already detached) and the commit it pointed at.
type gitRef struct {
	branch string
	commit string
}

// captureGitRef records dir's current branch/commit so it can be restored
// later if a subsequent step fails.
func captureGitRef(dir string) (gitRef, error) {
	branch, err := gitOutput(dir, "rev-parse", "--abbrev-ref", "HEAD")
	if err != nil {
		return gitRef{}, fmt.Errorf("capture starting state of %s: %w", dir, err)
	}
	commit, err := gitOutput(dir, "rev-parse", "HEAD")
	if err != nil {
		return gitRef{}, fmt.Errorf("capture starting state of %s: %w", dir, err)
	}
	if branch == "HEAD" {
		branch = ""
	}
	return gitRef{branch: branch, commit: commit}, nil
}

// restore returns dir to exactly the branch/commit ref describes. When ref
// was on a branch, restore lands back on that branch at that commit, never
// on a detached HEAD; ref.branch is only empty when the worktree already
// started detached.
func (ref gitRef) restore(dir string) error {
	if ref.branch != "" {
		if err := runCmd(dir, nil, "git", "checkout", ref.branch); err != nil {
			return err
		}
		return runCmd(dir, nil, "git", "reset", "--hard", ref.commit)
	}
	return runCmd(dir, nil, "git", "checkout", "--detach", ref.commit)
}

// rollbackPin restores the festival repo and both submodules to exactly
// where they stood before pinFromLatest began mutating them. It runs
// whenever pinFromLatest fails partway through, so a failed pin never
// leaves a submodule, or the superproject, sitting on an unrelated commit.
// Restoring camp and fest first means that if root and a submodule ref were
// captured identically (the uninitialized-submodule fallthrough this guards
// against), the submodule restore already lands root back on its starting
// ref; the explicit root restore below is a second, independent guarantee
// of the same outcome.
func (r *repoContext) rollbackPin(root, fest, camp gitRef) {
	if rerr := camp.restore(r.submodulePath("camp")); rerr != nil {
		fmt.Fprintf(os.Stderr, "WARNING: failed to restore camp to its starting state: %v\n", rerr)
	}
	if rerr := fest.restore(r.submodulePath("fest")); rerr != nil {
		fmt.Fprintf(os.Stderr, "WARNING: failed to restore fest to its starting state: %v\n", rerr)
	}
	if rerr := root.restore(r.Root); rerr != nil {
		fmt.Fprintf(os.Stderr, "WARNING: failed to restore festival repo to its starting state: %v\n", rerr)
	}
	if _, rerr := r.git("reset", "--", "fest", "camp"); rerr != nil {
		fmt.Fprintf(os.Stderr, "WARNING: failed to unstage submodule pointer changes during rollback: %v\n", rerr)
	}
}

func (r *repoContext) pinFromLatest(modeName, festSelector, campSelector string) (err error) {
	mode, err := modeConfig(modeName)
	if err != nil {
		return err
	}
	if err = ensureSubmodulesReady(r.Root); err != nil {
		return err
	}
	if err = r.ensureAllWorktreesClean(); err != nil {
		return err
	}

	// Capture exactly where the festival repo and both submodules stand
	// before anything below mutates them, so any failure can restore all
	// three to their starting branch/commit instead of leaving something
	// checked out on an unrelated release commit.
	startRoot, err := captureGitRef(r.Root)
	if err != nil {
		return err
	}
	startFest, err := captureGitRef(r.submodulePath("fest"))
	if err != nil {
		return err
	}
	startCamp, err := captureGitRef(r.submodulePath("camp"))
	if err != nil {
		return err
	}
	defer func() {
		if err != nil {
			r.rollbackPin(startRoot, startFest, startCamp)
		}
	}()

	if err = r.fetchReleaseRefs(); err != nil {
		return err
	}

	festTag, err := resolveSelectedTag(r.submodulePath("fest"), mode.Name, festSelector)
	if err != nil {
		return err
	}
	campTag, err := resolveSelectedTag(r.submodulePath("camp"), mode.Name, campSelector)
	if err != nil {
		return err
	}
	if festTag == "" || campTag == "" {
		fmt.Printf("ERROR: Missing %s tags.\n", mode.Name)
		fmt.Printf("fest latest %s: %s\n", mode.Name, valueOrNone(festTag))
		fmt.Printf("camp latest %s: %s\n", mode.Name, valueOrNone(campTag))
		switch mode.Name {
		case "stable":
			fmt.Println("For a first release, run:")
			fmt.Println("  just release draft-bootstrap <festival_version> <fest_version> <camp_version>")
		case "rc":
			fmt.Println("Create rc tags in fest/camp first, then rerun with mode=rc.")
		default:
			fmt.Println("Create dev tags in fest/camp first, then rerun with mode=dev.")
		}
		err = errors.New("missing component tags")
		return err
	}

	if err = r.checkoutSubmoduleTag("fest", festTag); err != nil {
		return err
	}
	if err = verifyCheckedOutTag(r.submodulePath("fest"), "fest", festTag); err != nil {
		return err
	}
	if err = r.checkoutSubmoduleTag("camp", campTag); err != nil {
		return err
	}
	if err = verifyCheckedOutTag(r.submodulePath("camp"), "camp", campTag); err != nil {
		return err
	}
	if err = r.stageSubmoduleRefs(); err != nil {
		return err
	}

	fmt.Printf("Pinned fest to: %s\n", festTag)
	fmt.Printf("Pinned camp to: %s\n", campTag)
	return nil
}

func runRequireStablePublishCredentials(ctx *repoContext) error {
	if _, err := exec.LookPath("gh"); err != nil {
		return errors.New("gh is required to verify stable publishing readiness")
	}
	if !ghAuthenticated() {
		return errors.New("gh is not authenticated")
	}

	secretNames, err := ghSecretNames(ctx.Root)
	if err != nil {
		return err
	}

	missing := false
	for _, name := range []string{"HOMEBREW_TAP_GITHUB_TOKEN", "AUR_SSH_KEY"} {
		if !contains(secretNames, name) {
			fmt.Printf("ERROR: %s is not configured for Obedience-Corp/festival.\n", name)
			switch name {
			case "HOMEBREW_TAP_GITHUB_TOKEN":
				fmt.Println("Stable release would fail when publishing the Homebrew cask.")
			case "AUR_SSH_KEY":
				fmt.Println("Stable release would fail when publishing the festival-bin AUR package.")
			}
			fmt.Println("Add it with:")
			fmt.Printf("  gh secret set %s --repo Obedience-Corp/festival\n", name)
			missing = true
		}
	}
	if missing {
		return errors.New("stable publish credentials are incomplete")
	}

	fmt.Println("Stable publish credentials are configured.")
	return nil
}

func runStatus(ctx *repoContext) error {
	_ = ctx.fetchReleaseRefs()

	branch, err := ctx.git("rev-parse", "--abbrev-ref", "HEAD")
	if err != nil {
		return err
	}

	fmt.Printf("festival branch: %s\n\n", branch)
	fmt.Println("Current submodule pins:")
	for _, sub := range submodules {
		sha, err := ctx.gitSubmodule(sub, "rev-parse", "--short", "HEAD")
		if err != nil {
			return err
		}
		tag, err := ctx.exactTag(sub)
		if err != nil {
			return err
		}
		if tag == "" {
			tag = "no tag"
		}
		fmt.Printf("  %s: %s (%s)\n", sub, sha, tag)
	}

	fmt.Println()
	fmt.Println("Latest available tags:")
	for _, modeName := range []string{"stable", "rc", "dev"} {
		fmt.Printf("  %s: fest=%s camp=%s\n",
			modeName,
			valueOrNone(latestTagForMode(ctx.submodulePath("fest"), modeName)),
			valueOrNone(latestTagForMode(ctx.submodulePath("camp"), modeName)),
		)
	}

	fmt.Println()
	if !ghAuthenticated() {
		fmt.Println("Homebrew stable publish: unknown (gh not authenticated)")
		fmt.Println("AUR stable publish: unknown (gh not authenticated)")
		return nil
	}

	secrets, err := ghSecretNames(ctx.Root)
	if err != nil {
		return err
	}
	if contains(secrets, "HOMEBREW_TAP_GITHUB_TOKEN") {
		fmt.Println("Homebrew stable publish: configured")
	} else {
		fmt.Println("Homebrew stable publish: missing HOMEBREW_TAP_GITHUB_TOKEN")
	}
	if contains(secrets, "AUR_SSH_KEY") {
		fmt.Println("AUR stable publish: configured")
	} else {
		fmt.Println("AUR stable publish: missing AUR_SSH_KEY")
	}

	return nil
}

func runCheckBundledModules(ctx *repoContext) error {
	fmt.Println("Checking bundled submodule module resolution:")
	for _, sub := range submodules {
		fmt.Printf("  %s: ", sub)
		if err := ctx.checkBundledModuleResolution(sub); err != nil {
			fmt.Println("failed")
			return err
		}
		fmt.Println("ok")
	}
	return nil
}

func runPreflight(ctx *repoContext, mode releaseMode) error {
	if err := ensureSubmodulesReady(ctx.Root); err != nil {
		return err
	}

	fmt.Println("=== Release Preflight ===")
	fmt.Println()
	fmt.Println("Submodule pins:")
	for _, sub := range submodules {
		sha, err := ctx.gitSubmodule(sub, "rev-parse", "--short", "HEAD")
		if err != nil {
			return err
		}
		tag, err := ctx.exactTag(sub)
		if err != nil {
			return err
		}
		if tag == "" {
			tag = "no tag"
		}
		branch, err := ctx.gitSubmodule(sub, "rev-parse", "--abbrev-ref", "HEAD")
		if err != nil {
			return err
		}
		fmt.Printf("  %s: %s (%s) [branch: %s]\n", sub, sha, tag, branch)
	}
	fmt.Println()

	if err := ctx.ensureAllWorktreesClean(); err != nil {
		return err
	}
	fmt.Println("Submodules: clean")
	fmt.Println()

	if mode.Name == "stable" {
		fmt.Println("Checking stable publisher secrets:")
		if err := runRequireStablePublishCredentials(ctx); err != nil {
			return err
		}
		fmt.Println()
	}

	fmt.Println("Checking tagged release pins:")
	if err := ctx.just("test", "release-pins", mode.Name); err != nil {
		return err
	}
	fmt.Println()

	fmt.Println("Checking bundled submodule module resolution:")
	if err := ctx.just("test", "bundled-module-resolution"); err != nil {
		return err
	}
	fmt.Println()

	fmt.Println("Checking stable/dev docs profile:")
	if err := ctx.just("test", "docs-profile"); err != nil {
		return err
	}
	fmt.Println()

	fmt.Println("Testing release operator:")
	if err := ctx.just("test", "release-operator"); err != nil {
		return err
	}
	fmt.Println()

	fmt.Println("Building CLIs:")
	if err := ctx.justEnv(map[string]string{"CLI_PROFILE": mode.BuildProfile}, "build", "all"); err != nil {
		return err
	}
	fmt.Println()

	fmt.Println("Beginner-path smoke:")
	if err := ctx.just("test", "beginner-path-smoke"); err != nil {
		return err
	}
	fmt.Println()

	fmt.Println("Recent tags:")
	tags, err := gitLines(ctx.Root, "tag", "-l", "--sort=-v:refname")
	if err != nil {
		return err
	}
	if len(tags) == 0 {
		fmt.Println("  (none)")
	} else {
		for i, tag := range tags {
			if i == 5 {
				break
			}
			fmt.Println(tag)
		}
	}
	fmt.Println()
	fmt.Println("Preflight complete.")
	fmt.Println("  One-command: just release stable fest=latest camp=keep")
	fmt.Println("  Planner:     just release plan mode=stable fest=latest camp=keep")
	fmt.Println("  Manual:      just release draft <version> | draft-rc <version> <n> | draft-dev <version> <n>")
	return nil
}

func runDraftFromLatest(ctx *repoContext, version string, mode releaseMode, iteration int, festSelector, campSelector, currentFestTag, currentCampTag string) error {
	releaseTag := releaseTagFor(mode, version, iteration)
	if err := ctx.ensureTagAbsent(releaseTag); err != nil {
		return err
	}
	if err := ctx.pinFromLatest(mode.Name, festSelector, campSelector); err != nil {
		return err
	}
	if err := ctx.runDocs(mode); err != nil {
		return err
	}
	if err := ctx.stageReleaseArtifacts(); err != nil {
		return err
	}

	festTag, campTag, err := ctx.exactComponentTags(mode.Name)
	if err != nil {
		return err
	}
	if !operator.TagMatchesMode(festTag, mode.Name) || !operator.TagMatchesMode(campTag, mode.Name) {
		return fmt.Errorf("submodules are not pinned to exact %s tags after refresh", mode.Name)
	}

	if err := ctx.shipPinnedArtifacts(releaseTag, currentFestTag, currentCampTag, festTag, campTag); err != nil {
		return err
	}
	if err := runPreflight(ctx, mode); err != nil {
		return err
	}

	fmt.Println()
	fmt.Printf("=== Creating %s release %s ===\n", mode.ReleaseLabel, releaseTag)
	if err := ctx.createAndPushFestivalTag(releaseTag, "Release "+releaseTag); err != nil {
		return err
	}
	fmt.Println()
	fmt.Printf("%s release %s pushed.\n", mode.ReleaseLabel, releaseTag)
	fmt.Printf("fest pinned to: %s\n", festTag)
	fmt.Printf("camp pinned to: %s\n", campTag)
	fmt.Println("Monitor: gh run watch --repo Obedience-Corp/festival")
	return nil
}

func runDraftExplicit(ctx *repoContext, version string, mode releaseMode, iteration int) error {
	releaseTag := releaseTagFor(mode, version, iteration)
	if err := ctx.ensureTagAbsent(releaseTag); err != nil {
		return err
	}
	if err := runPreflight(ctx, mode); err != nil {
		return err
	}

	fmt.Println()
	fmt.Printf("=== Creating %s release %s ===\n", mode.ReleaseLabel, releaseTag)
	if err := ctx.createAndPushFestivalTag(releaseTag, "Release "+releaseTag); err != nil {
		return err
	}
	fmt.Println()
	switch mode.Name {
	case "stable":
		fmt.Printf("Stable release %s pushed. CI will build and publish.\n", releaseTag)
	case "rc":
		fmt.Printf("RC release %s pushed. CI will build and publish as prerelease.\n", releaseTag)
	case "dev":
		fmt.Printf("Dev release %s pushed. CI will build and publish as prerelease.\n", releaseTag)
		fmt.Println("To clean up later:")
		fmt.Printf("  gh release delete %s --repo Obedience-Corp/festival --yes\n", releaseTag)
		fmt.Printf("  git push origin --delete %s && git tag -d %s\n", releaseTag, releaseTag)
	}
	fmt.Println("Monitor: gh run watch --repo Obedience-Corp/festival")
	return nil
}

func runDraftBootstrap(ctx *repoContext, festivalVersion, festVersion, campVersion string) error {
	stable, err := modeConfig("stable")
	if err != nil {
		return err
	}
	if err := ensureSubmodulesReady(ctx.Root); err != nil {
		return err
	}
	if err := ctx.ensureAllWorktreesClean(); err != nil {
		return err
	}
	if err := ctx.fetchReleaseRefs(); err != nil {
		return err
	}

	releaseTag := releaseTagFor(stable, festivalVersion, 0)
	festTag := "v" + festVersion
	campTag := "v" + campVersion

	if err := ctx.ensureSubmoduleTagAbsent("fest", festTag); err != nil {
		return err
	}
	if err := ctx.ensureSubmoduleTagAbsent("camp", campTag); err != nil {
		return err
	}
	if err := ctx.createAndPushSubmoduleTag("fest", festTag); err != nil {
		return err
	}
	if err := ctx.createAndPushSubmoduleTag("camp", campTag); err != nil {
		return err
	}

	if err := ctx.checkoutSubmoduleTag("fest", festTag); err != nil {
		return err
	}
	if err := ctx.checkoutSubmoduleTag("camp", campTag); err != nil {
		return err
	}
	if err := ctx.runDocs(stable); err != nil {
		return err
	}
	if err := ctx.stageReleaseArtifacts(); err != nil {
		return err
	}
	if err := ctx.shipPinnedArtifacts(releaseTag, "", "", festTag, campTag); err != nil {
		return err
	}

	if err := ctx.ensureTagAbsent(releaseTag); err != nil {
		return err
	}
	if err := runPreflight(ctx, stable); err != nil {
		return err
	}

	fmt.Println()
	fmt.Printf("=== Creating stable release %s ===\n", releaseTag)
	if err := ctx.createAndPushFestivalTag(releaseTag, "Release "+releaseTag); err != nil {
		return err
	}
	fmt.Println()
	fmt.Printf("Stable release %s pushed.\n", releaseTag)
	fmt.Printf("fest pinned to: %s\n", festTag)
	fmt.Printf("camp pinned to: %s\n", campTag)
	fmt.Println("Monitor: gh run watch --repo Obedience-Corp/festival")
	return nil
}

func runPlanWithRoot(opts planOptions) error {
	ctx, err := newRepoContext(opts.RepoRoot)
	if err != nil {
		return err
	}

	state, err := collectState(ctx.Root, opts.Channel, opts.FestSelector, opts.CampSelector)
	if err != nil {
		return err
	}

	plan, err := operator.DeriveBundlePlan(state)
	if err != nil {
		return err
	}
	mode, err := modeConfig(plan.Channel)
	if err != nil {
		return err
	}

	fmt.Println()
	fmt.Println("== Release Plan ==")
	fmt.Printf("  channel: %s\n", opts.Channel)
	fmt.Printf("  festival branch: %s\n", state.CurrentBranch)
	fmt.Printf("  planned release tag: %s\n", plan.ReleaseTag)
	fmt.Printf("  fest: %s -> %s (%s)\n", valueOrNone(state.CurrentPinnedFestTag), state.FestTag, opts.FestSelector)
	fmt.Printf("  camp: %s -> %s (%s)\n", valueOrNone(state.CurrentPinnedCampTag), state.CampTag, opts.CampSelector)
	fmt.Printf("  docs profile: %s\n", mode.BuildProfile)
	fmt.Printf("  commit message: %s\n", releaseCommitMessage(state.CurrentPinnedFestTag, state.CurrentPinnedCampTag, state.FestTag, state.CampTag))
	fmt.Println()
	fmt.Println(plan.Description)
	fmt.Printf("Command: just release %s fest=%s camp=%s\n", opts.Channel, opts.FestSelector, opts.CampSelector)
	fmt.Println()
	return nil
}

func runBundleWithRoot(opts bundleOptions) error {
	ctx, err := newRepoContext(opts.RepoRoot)
	if err != nil {
		return err
	}

	if err := ctx.prepareMainForBundle(); err != nil {
		return err
	}

	state, err := collectState(ctx.Root, opts.Channel, opts.FestSelector, opts.CampSelector)
	if err != nil {
		return err
	}

	plan, err := operator.DeriveBundlePlan(state)
	if err != nil {
		return err
	}
	mode, err := modeConfig(plan.Channel)
	if err != nil {
		return err
	}

	fmt.Println()
	fmt.Println("== Current State ==")
	fmt.Printf("  festival branch: %s\n", state.CurrentBranch)
	fmt.Printf("  fest: %s -> %s (%s)\n", valueOrNone(state.CurrentPinnedFestTag), state.FestTag, opts.FestSelector)
	fmt.Printf("  camp: %s -> %s (%s)\n", valueOrNone(state.CurrentPinnedCampTag), state.CampTag, opts.CampSelector)
	fmt.Println()
	fmt.Printf("== %s Bundle Release ==\n", strings.ToUpper(opts.Channel))
	fmt.Println(plan.Description)
	fmt.Printf("Using selected %s tags for camp and fest.\n", opts.Channel)
	fmt.Println()

	return runDraftFromLatest(ctx, plan.Version, mode, plan.Iteration, opts.FestSelector, opts.CampSelector, state.CurrentPinnedFestTag, state.CurrentPinnedCampTag)
}

func runCleanup(ctx *repoContext, tag string) error {
	fmt.Printf("Deleting GitHub release %s...\n", tag)
	if err := runCmd(ctx.Root, nil, "gh", "release", "delete", tag, "--repo", festivalRepoSlug, "--yes"); err != nil {
		fmt.Printf("  No GitHub release found for %s\n", tag)
	}
	fmt.Printf("Deleting remote tag %s...\n", tag)
	if err := ctx.runGit("push", "origin", "--delete", tag); err != nil {
		fmt.Println("  Remote tag not found")
	}
	fmt.Printf("Deleting local tag %s...\n", tag)
	if err := ctx.runGit("tag", "-d", tag); err != nil {
		fmt.Println("  Local tag not found")
	}
	fmt.Println("Cleanup complete.")
	return nil
}

func ghSecretNames(dir string) ([]string, error) {
	out, err := cmdOutput(dir, nil, "gh", "secret", "list", "--repo", festivalRepoSlug)
	if err != nil {
		return nil, err
	}
	lines := strings.Split(strings.TrimSpace(out), "\n")
	names := make([]string, 0, len(lines))
	for _, line := range lines {
		fields := strings.Fields(line)
		if len(fields) == 0 {
			continue
		}
		names = append(names, fields[0])
	}
	return names, nil
}

func ghAuthenticated() bool {
	cmd := exec.Command("gh", "auth", "status")
	cmd.Stdout = io.Discard
	cmd.Stderr = io.Discard
	return cmd.Run() == nil
}

func contains(items []string, want string) bool {
	for _, item := range items {
		if item == want {
			return true
		}
	}
	return false
}

func valueOrNone(v string) string {
	if strings.TrimSpace(v) == "" {
		return "<none>"
	}
	return v
}

func envList(overrides map[string]string) []string {
	if len(overrides) == 0 {
		return nil
	}
	env := append([]string{}, os.Environ()...)
	for key, value := range overrides {
		env = append(env, key+"="+value)
	}
	return env
}
