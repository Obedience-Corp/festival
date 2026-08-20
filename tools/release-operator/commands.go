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

// Component is one submodule that participates in a bundled festival release.
type Component struct {
	// Dir is the submodule path relative to the repo root, and the display name.
	Dir string
	// Repo is the GitHub slug used for tag lookups and release links.
	Repo string
	// FlagName is the CLI selector name, for example "fest" in --fest-tag.
	FlagName string
	// BinaryName is the shipped executable name. It matches Dir for every
	// component except the hub, whose submodule directory is
	// festival-installer but whose built binary is named festival.
	BinaryName string
}

var components = []Component{
	{Dir: "fest", Repo: "Obedience-Corp/fest", FlagName: "fest", BinaryName: "fest"},
	{Dir: "camp", Repo: "Obedience-Corp/camp", FlagName: "camp", BinaryName: "camp"},
	{Dir: "festival-installer", Repo: "Obedience-Corp/festival-installer", FlagName: "festival-installer", BinaryName: "festival"},
}

// componentDirs returns every component's Dir, in declaration order, for
// callers that need a plain path list (git add, git diff pathspecs).
func componentDirs() []string {
	dirs := make([]string, len(components))
	for i, c := range components {
		dirs[i] = c.Dir
	}
	return dirs
}

// justRecipeParamName converts a component directory into the parameter
// name .justfiles/release.just's draft-bootstrap recipe uses for it, for
// example "festival-installer" -> "festival_installer_version". just
// parameter names cannot contain hyphens, so the recipe uses underscores;
// this keeps printed usage hints in sync with the recipe signature without
// hardcoding a fixed argument count.
func justRecipeParamName(dir string) string {
	return strings.ReplaceAll(dir, "-", "_") + "_version"
}

// joinAnd renders items as an English list: "a", "a and b", or
// "a, b, and c". Used for release commit messages so a fourth component
// reads naturally without a special case.
func joinAnd(items []string) string {
	switch len(items) {
	case 0:
		return ""
	case 1:
		return items[0]
	case 2:
		return items[0] + " and " + items[1]
	default:
		return strings.Join(items[:len(items)-1], ", ") + ", and " + items[len(items)-1]
	}
}

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
	if err := r.ensureRootWorktreeClean(); err != nil {
		return err
	}
	return r.ensureSubmoduleWorktreesClean()
}

// ensureRootWorktreeClean checks only the festival repo's own worktree. It
// is split out from ensureSubmoduleWorktreesClean so callers can reject a
// dirty superproject before ensureSubmodulesReady runs: initializing a
// submodule is itself a mutation, and a command that is about to refuse for
// a dirty tree should not perform that mutation first.
func (r *repoContext) ensureRootWorktreeClean() error {
	dirty, err := worktreeDirty(r.Root)
	if err != nil {
		return err
	}
	if dirty {
		return errors.New("festival repo has uncommitted changes")
	}
	return nil
}

// ensureSubmoduleWorktreesClean checks each submodule's own worktree. It
// must only run after ensureSubmodulesReady, since checking dirty state on
// an uninitialized submodule directory silently resolves against the
// superproject instead of the submodule.
func (r *repoContext) ensureSubmoduleWorktreesClean() error {
	for _, c := range components {
		dirty, err := worktreeDirty(r.submodulePath(c.Dir))
		if err != nil {
			return err
		}
		if dirty {
			return fmt.Errorf("%s has uncommitted changes", c.Dir)
		}
	}
	return nil
}

func (r *repoContext) fetchReleaseRefs() error {
	if err := runCmd(r.Root, nil, "git", "fetch", "--prune", "--prune-tags", "origin", "+refs/tags/*:refs/tags/*", "+refs/heads/main:refs/remotes/origin/main"); err != nil {
		return err
	}
	for _, c := range components {
		if err := runCmd(r.submodulePath(c.Dir), nil, "git", "fetch", "--prune", "--prune-tags", "origin", "+refs/tags/*:refs/tags/*"); err != nil {
			return err
		}
	}
	return nil
}

func (r *repoContext) stageReleaseArtifacts() error {
	args := append([]string{"add"}, componentDirs()...)
	args = append(args, "docs/cli-reference")
	return r.runGit(args...)
}

func (r *repoContext) stageSubmoduleRefs() error {
	return r.runGit(append([]string{"add"}, componentDirs()...)...)
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

// exactComponentTags returns the exact modeName tag currently checked out
// for every component, keyed by Component.Dir. Errors if any component is
// not pinned to an exact tag matching modeName.
func (r *repoContext) exactComponentTags(modeName string) (map[string]string, error) {
	tags := make(map[string]string, len(components))
	for _, c := range components {
		tag, err := exactTagAtForMode(r.submodulePath(c.Dir), modeName)
		if err != nil {
			return nil, err
		}
		if tag == "" {
			return nil, fmt.Errorf("%s is not pinned to an exact tag", c.Dir)
		}
		tags[c.Dir] = tag
	}
	return tags, nil
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

// releaseCommitMessage summarizes which components changed tag, keyed by
// Component.Dir in both current and selected. When nothing changed (a docs
// or metadata-only refresh), it lists every component's current tag instead.
func releaseCommitMessage(current, selected map[string]string) string {
	var changed []string
	for _, c := range components {
		if current[c.Dir] != selected[c.Dir] {
			changed = append(changed, fmt.Sprintf("%s %s", c.FlagName, selected[c.Dir]))
		}
	}
	if len(changed) > 0 {
		return "Release: pin " + joinAnd(changed)
	}

	all := make([]string, 0, len(components))
	for _, c := range components {
		all = append(all, fmt.Sprintf("%s %s", c.FlagName, selected[c.Dir]))
	}
	return "Release: refresh bundled docs for " + joinAnd(all)
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

// shipPinnedArtifacts commits and ships the currently-staged submodule
// pointer and docs changes. current and selected are keyed by Component.Dir;
// selected holds what each component is now pinned to, current holds what
// each was pinned to before this run.
func (r *repoContext) shipPinnedArtifacts(releaseTag string, current, selected map[string]string) error {
	diffPaths := append(componentDirs(), "docs/cli-reference")
	hasDiff, err := r.cachedDiffExists(diffPaths...)
	if err != nil {
		return err
	}
	if !hasDiff {
		var pins []string
		for _, c := range components {
			pins = append(pins, fmt.Sprintf("%s=%s", c.FlagName, selected[c.Dir]))
		}
		fmt.Printf("Submodule pointers and docs already at %s; no release commit needed.\n", strings.Join(pins, ", "))
		return nil
	}

	branch, err := r.currentBranch()
	if err != nil {
		return err
	}
	message := releaseCommitMessage(current, selected)
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
	for _, c := range components {
		path := filepath.Join(root, c.Dir)
		if submoduleIsIndependent(path) {
			continue
		}

		fmt.Printf("%s submodule is not initialized; running 'git submodule update --init -- %s'\n", c.Dir, c.Dir)
		if err := runCmd(root, nil, "git", "submodule", "update", "--init", "--", c.Dir); err != nil {
			return fmt.Errorf("initialize %s submodule: %w\nrun 'git submodule update --init -- %s' in %s and retry", c.Dir, err, c.Dir, root)
		}
		if !submoduleIsIndependent(path) {
			return fmt.Errorf("%s did not become an independent git worktree after 'git submodule update --init'; refusing to continue rather than risk resolving refs against the superproject", c.Dir)
		}

		if err := runCmd(path, nil, "git", "fetch", "--prune", "--prune-tags", "origin", "+refs/tags/*:refs/tags/*"); err != nil {
			return fmt.Errorf("fetch tags for %s after initializing submodule: %w", c.Dir, err)
		}
		fmt.Printf("%s submodule initialized and tags fetched\n", c.Dir)
	}
	return nil
}

// verifyCheckedOutTag confirms dir's HEAD is exactly the commit the
// requested tag points at, rather than trusting the checkout succeeded
// silently against the wrong repository or an unrelated commit. HEAD is
// allowed to carry other tags too: a release commit is routinely tagged
// both vX.Y.Z-rc.N and, later, vX.Y.Z, and that is not itself a mismatch.
// headMatchesTag compares the requested tag's own commit against HEAD
// directly, so it is unaffected by any other tags also pointing at HEAD
// (unlike exactTagAt, which returns only the single highest-sorting tag).
func verifyCheckedOutTag(dir, name, tag string) error {
	match, err := headMatchesTag(dir, tag)
	if err != nil {
		return fmt.Errorf("verify %s checkout: %w", name, err)
	}
	if match {
		return nil
	}
	tags, tagsErr := exactTagsAt(dir)
	if tagsErr != nil || len(tags) == 0 {
		return fmt.Errorf("%s HEAD does not resolve to tag %q after checking it out; refusing to trust a mismatched pin", name, tag)
	}
	return fmt.Errorf("%s HEAD resolved to %s after checking out %q; refusing to trust a mismatched pin", name, strings.Join(tags, ", "), tag)
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
// started detached. The hard reset only runs when the branch has actually
// moved off the captured commit, so restore does not rewind a branch tip
// that nothing touched.
func (ref gitRef) restore(dir string) error {
	if ref.branch != "" {
		if err := runCmd(dir, nil, "git", "checkout", ref.branch); err != nil {
			return err
		}
		current, err := gitOutput(dir, "rev-parse", "HEAD")
		if err != nil {
			return err
		}
		if current == ref.commit {
			return nil
		}
		return runCmd(dir, nil, "git", "reset", "--hard", ref.commit)
	}
	return runCmd(dir, nil, "git", "checkout", "--detach", ref.commit)
}

// rollbackPin restores the festival repo and every component submodule to
// exactly where they stood before pinFromLatest began mutating them. It runs
// whenever pinFromLatest fails partway through, so a failed pin never
// leaves a submodule, or the superproject, sitting on an unrelated commit.
// Restoring components first means that if root and a submodule ref were
// captured identically (the uninitialized-submodule fallthrough this guards
// against), the submodule restore already lands root back on its starting
// ref; the explicit root restore below is a second, independent guarantee
// of the same outcome. Components are restored in reverse declaration order
// so the pattern matches the historical camp-before-fest restore order.
func (r *repoContext) rollbackPin(root gitRef, starts map[string]gitRef) {
	for i := len(components) - 1; i >= 0; i-- {
		c := components[i]
		if rerr := starts[c.Dir].restore(r.submodulePath(c.Dir)); rerr != nil {
			fmt.Fprintf(os.Stderr, "WARNING: failed to restore %s to its starting state: %v\n", c.Dir, rerr)
		}
	}
	if rerr := root.restore(r.Root); rerr != nil {
		fmt.Fprintf(os.Stderr, "WARNING: failed to restore festival repo to its starting state: %v\n", rerr)
	}
	if _, rerr := r.git(append([]string{"reset", "--"}, componentDirs()...)...); rerr != nil {
		fmt.Fprintf(os.Stderr, "WARNING: failed to unstage submodule pointer changes during rollback: %v\n", rerr)
	}
}

func (r *repoContext) pinFromLatest(modeName string, selectors map[string]string) (err error) {
	mode, err := modeConfig(modeName)
	if err != nil {
		return err
	}
	// Check the superproject's own worktree before ensureSubmodulesReady:
	// auto-initializing a submodule is itself a mutation, and a dirty root
	// should refuse before that mutation happens, not after.
	if err = r.ensureRootWorktreeClean(); err != nil {
		return err
	}
	if err = ensureSubmodulesReady(r.Root); err != nil {
		return err
	}
	if err = r.ensureSubmoduleWorktreesClean(); err != nil {
		return err
	}

	// Capture exactly where the festival repo and every component submodule
	// stand before anything below mutates them, so any failure can restore
	// all of them to their starting branch/commit instead of leaving
	// something checked out on an unrelated release commit.
	startRoot, err := captureGitRef(r.Root)
	if err != nil {
		return err
	}
	starts := make(map[string]gitRef, len(components))
	for _, c := range components {
		starts[c.Dir], err = captureGitRef(r.submodulePath(c.Dir))
		if err != nil {
			return err
		}
	}
	defer func() {
		if err != nil {
			r.rollbackPin(startRoot, starts)
		}
	}()

	if err = r.fetchReleaseRefs(); err != nil {
		return err
	}

	tags := make(map[string]string, len(components))
	missing := false
	for _, c := range components {
		tag, terr := resolveSelectedTag(r.submodulePath(c.Dir), mode.Name, selectors[c.Dir])
		if terr != nil {
			err = terr
			return err
		}
		tags[c.Dir] = tag
		if tag == "" {
			missing = true
		}
	}
	if missing {
		fmt.Printf("ERROR: Missing %s tags.\n", mode.Name)
		for _, c := range components {
			fmt.Printf("%s latest %s: %s\n", c.Dir, mode.Name, valueOrNone(tags[c.Dir]))
		}
		switch mode.Name {
		case "stable":
			fmt.Println("For a first release, run:")
			fmt.Print("  just release draft-bootstrap <festival_version>")
			for _, c := range components {
				fmt.Printf(" <%s>", justRecipeParamName(c.Dir))
			}
			fmt.Println()
		case "rc":
			fmt.Println("Create rc tags in fest/camp/festival-installer first, then rerun with mode=rc.")
		default:
			fmt.Println("Create dev tags in fest/camp/festival-installer first, then rerun with mode=dev.")
		}
		err = errors.New("missing component tags")
		return err
	}

	for _, c := range components {
		if err = r.checkoutSubmoduleTag(c.Dir, tags[c.Dir]); err != nil {
			return err
		}
		if err = verifyCheckedOutTag(r.submodulePath(c.Dir), c.Dir, tags[c.Dir]); err != nil {
			return err
		}
	}
	if err = r.stageSubmoduleRefs(); err != nil {
		return err
	}

	for _, c := range components {
		fmt.Printf("Pinned %s to: %s\n", c.Dir, tags[c.Dir])
	}
	return nil
}

// publishSecret is a repository secret a stable release needs. Both the
// preflight check and the status report read this one list so status cannot
// claim every publisher is ready while preflight later fails on a secret
// status never displayed.
type publishSecret struct {
	Name    string
	Label   string
	Failure string
}

var publishSecrets = []publishSecret{
	{
		Name:    "HOMEBREW_TAP_GITHUB_TOKEN",
		Label:   "Homebrew stable publish",
		Failure: "Stable release would fail when publishing the Homebrew cask.",
	},
	{
		Name:    "AUR_SSH_KEY",
		Label:   "AUR stable publish",
		Failure: "Stable release would fail when publishing the festival-bin AUR package.",
	},
	{
		Name:    "MARKETPLACE_PUBLISH_TOKEN",
		Label:   "Marketplace stable publish",
		Failure: "Stable release would fail when publishing the marketplace entry (.github/workflows/release.yaml).",
	},
}

// stablePublishSecrets lists the GitHub repo secrets a stable release
// needs, in report order. require-stable-publish-credentials and status
// both read from this single list, so a newly required secret cannot drift
// between the two checks the way MARKETPLACE_PUBLISH_TOKEN once did (it was
// checked by the former but silently absent from the latter's report).
var stablePublishSecrets = []struct {
	Name        string
	Label       string
	FailureNote string
}{
	{
		Name:        "HOMEBREW_TAP_GITHUB_TOKEN",
		Label:       "Homebrew",
		FailureNote: "Stable release would fail when publishing the Homebrew cask.",
	},
	{
		Name:        "AUR_SSH_KEY",
		Label:       "AUR",
		FailureNote: "Stable release would fail when publishing the festival-bin AUR package.",
	},
	{
		Name:        "MARKETPLACE_PUBLISH_TOKEN",
		Label:       "Marketplace",
		FailureNote: "Stable release would fail when publishing the marketplace entry (.github/workflows/release.yaml).",
	},
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
	for _, s := range stablePublishSecrets {
		if !contains(secretNames, s.Name) {
			fmt.Printf("ERROR: %s is not configured for Obedience-Corp/festival.\n", s.Name)
			fmt.Println(s.FailureNote)
			fmt.Println("Add it with:")
			fmt.Printf("  gh secret set %s --repo Obedience-Corp/festival\n", s.Name)
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
	for _, c := range components {
		sha, err := ctx.gitSubmodule(c.Dir, "rev-parse", "--short", "HEAD")
		if err != nil {
			return err
		}
		tag, err := ctx.exactTag(c.Dir)
		if err != nil {
			return err
		}
		if tag == "" {
			tag = "no tag"
		}
		fmt.Printf("  %s: %s (%s)\n", c.Dir, sha, tag)
	}

	fmt.Println()
	fmt.Println("Latest available tags:")
	for _, modeName := range []string{"stable", "rc", "dev"} {
		var parts []string
		for _, c := range components {
			parts = append(parts, fmt.Sprintf("%s=%s", c.FlagName, valueOrNone(latestTagForMode(ctx.submodulePath(c.Dir), modeName))))
		}
		fmt.Printf("  %s: %s\n", modeName, strings.Join(parts, " "))
	}

	fmt.Println()
	if !ghAuthenticated() {
		for _, s := range stablePublishSecrets {
			fmt.Printf("%s stable publish: unknown (gh not authenticated)\n", s.Label)
		}
		return nil
	}

	secrets, err := ghSecretNames(ctx.Root)
	if err != nil {
		return err
	}
	for _, s := range stablePublishSecrets {
		if contains(secrets, s.Name) {
			fmt.Printf("%s stable publish: configured\n", s.Label)
		} else {
			fmt.Printf("%s stable publish: missing %s\n", s.Label, s.Name)
		}
	}

	return nil
}

func runCheckBundledModules(ctx *repoContext) error {
	fmt.Println("Checking bundled submodule module resolution:")
	for _, c := range components {
		fmt.Printf("  %s: ", c.Dir)
		if err := ctx.checkBundledModuleResolution(c.Dir); err != nil {
			fmt.Println("failed")
			return err
		}
		fmt.Println("ok")
	}
	return nil
}

func runPreflight(ctx *repoContext, mode releaseMode) error {
	// Check the superproject's own worktree before ensureSubmodulesReady:
	// auto-initializing a submodule is itself a mutation, and a dirty root
	// should refuse before that mutation happens, not after.
	if err := ctx.ensureRootWorktreeClean(); err != nil {
		return err
	}
	if err := ensureSubmodulesReady(ctx.Root); err != nil {
		return err
	}

	fmt.Println("=== Release Preflight ===")
	fmt.Println()
	fmt.Println("Submodule pins:")
	for _, c := range components {
		sha, err := ctx.gitSubmodule(c.Dir, "rev-parse", "--short", "HEAD")
		if err != nil {
			return err
		}
		tag, err := ctx.exactTag(c.Dir)
		if err != nil {
			return err
		}
		if tag == "" {
			tag = "no tag"
		}
		branch, err := ctx.gitSubmodule(c.Dir, "rev-parse", "--abbrev-ref", "HEAD")
		if err != nil {
			return err
		}
		fmt.Printf("  %s: %s (%s) [branch: %s]\n", c.Dir, sha, tag, branch)
	}
	fmt.Println()

	if err := ctx.ensureSubmoduleWorktreesClean(); err != nil {
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

func runDraftFromLatest(ctx *repoContext, version string, mode releaseMode, iteration int, selectors, currentPinned map[string]string) error {
	releaseTag := releaseTagFor(mode, version, iteration)
	if err := ctx.ensureTagAbsent(releaseTag); err != nil {
		return err
	}
	if err := ctx.pinFromLatest(mode.Name, selectors); err != nil {
		return err
	}
	if err := ctx.runDocs(mode); err != nil {
		return err
	}
	if err := ctx.stageReleaseArtifacts(); err != nil {
		return err
	}

	tags, err := ctx.exactComponentTags(mode.Name)
	if err != nil {
		return err
	}
	for _, c := range components {
		if !operator.TagMatchesMode(tags[c.Dir], mode.Name) {
			return fmt.Errorf("submodules are not pinned to exact %s tags after refresh", mode.Name)
		}
	}

	if err := ctx.shipPinnedArtifacts(releaseTag, currentPinned, tags); err != nil {
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
	for _, c := range components {
		fmt.Printf("%s pinned to: %s\n", c.Dir, tags[c.Dir])
	}
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

// runDraftBootstrap creates the first stable tag for every component that
// does not have one yet, keyed by Component.Dir in versions (bare version
// numbers, no leading v), then bundles and tags the first festival release.
func runDraftBootstrap(ctx *repoContext, festivalVersion string, versions map[string]string) error {
	stable, err := modeConfig("stable")
	if err != nil {
		return err
	}
	if err := ctx.ensureRootWorktreeClean(); err != nil {
		return err
	}
	if err := ensureSubmodulesReady(ctx.Root); err != nil {
		return err
	}
	if err := ctx.ensureSubmoduleWorktreesClean(); err != nil {
		return err
	}
	if err := ctx.fetchReleaseRefs(); err != nil {
		return err
	}

	releaseTag := releaseTagFor(stable, festivalVersion, 0)
	tags := make(map[string]string, len(components))
	for _, c := range components {
		tags[c.Dir] = "v" + versions[c.Dir]
	}

	for _, c := range components {
		if err := ctx.ensureSubmoduleTagAbsent(c.Dir, tags[c.Dir]); err != nil {
			return err
		}
	}
	for _, c := range components {
		if err := ctx.createAndPushSubmoduleTag(c.Dir, tags[c.Dir]); err != nil {
			return err
		}
	}

	for _, c := range components {
		if err := ctx.checkoutSubmoduleTag(c.Dir, tags[c.Dir]); err != nil {
			return err
		}
		if err := verifyCheckedOutTag(ctx.submodulePath(c.Dir), c.Dir, tags[c.Dir]); err != nil {
			return err
		}
	}
	if err := ctx.runDocs(stable); err != nil {
		return err
	}
	if err := ctx.stageReleaseArtifacts(); err != nil {
		return err
	}
	if err := ctx.shipPinnedArtifacts(releaseTag, map[string]string{}, tags); err != nil {
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
	for _, c := range components {
		fmt.Printf("%s pinned to: %s\n", c.Dir, tags[c.Dir])
	}
	fmt.Println("Monitor: gh run watch --repo Obedience-Corp/festival")
	return nil
}

// selectorArgsString renders selectors as a "just release" command-line
// hint, one flag=value token per component, in declaration order.
func selectorArgsString(selectors map[string]string) string {
	parts := make([]string, 0, len(components))
	for _, c := range components {
		parts = append(parts, fmt.Sprintf("%s=%s", c.FlagName, selectors[c.Dir]))
	}
	return strings.Join(parts, " ")
}

func runPlanWithRoot(opts planOptions) error {
	ctx, err := newRepoContext(opts.RepoRoot)
	if err != nil {
		return err
	}

	state, err := collectState(ctx.Root, opts.Channel, opts.Selectors)
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
	for _, c := range components {
		fmt.Printf("  %s: %s -> %s (%s)\n", c.Dir, valueOrNone(state.CurrentPinned[c.Dir]), state.SelectedTags[c.Dir], opts.Selectors[c.Dir])
	}
	fmt.Printf("  docs profile: %s\n", mode.BuildProfile)
	fmt.Printf("  commit message: %s\n", releaseCommitMessage(state.CurrentPinned, state.SelectedTags))
	fmt.Println()
	fmt.Println(plan.Description)
	fmt.Printf("Command: just release %s %s\n", opts.Channel, selectorArgsString(opts.Selectors))
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

	state, err := collectState(ctx.Root, opts.Channel, opts.Selectors)
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
	for _, c := range components {
		fmt.Printf("  %s: %s -> %s (%s)\n", c.Dir, valueOrNone(state.CurrentPinned[c.Dir]), state.SelectedTags[c.Dir], opts.Selectors[c.Dir])
	}
	fmt.Println()
	fmt.Printf("== %s Bundle Release ==\n", strings.ToUpper(opts.Channel))
	fmt.Println(plan.Description)
	fmt.Printf("Using selected %s tags for every component.\n", opts.Channel)
	fmt.Println()

	return runDraftFromLatest(ctx, plan.Version, mode, plan.Iteration, opts.Selectors, state.CurrentPinned)
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
