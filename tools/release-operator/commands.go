package main

import (
	"archive/tar"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/Obedience-Corp/festival/tools/release-operator/internal/operator"
)

var submodules = []string{"fest", "camp"}

type repoContext struct {
	Root string
}

type stableReadinessReport struct {
	Ready  bool
	Issues []string
}

func newRepoContext(root string) (*repoContext, error) {
	absRoot, err := filepath.Abs(root)
	if err != nil {
		return nil, fmt.Errorf("resolve repo root: %w", err)
	}
	return &repoContext{Root: absRoot}, nil
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

func (r *repoContext) latestComponentTags(modeName string) (festTag string, campTag string, err error) {
	mode, err := modeConfig(modeName)
	if err != nil {
		return "", "", err
	}
	festTag = latestTagForMode(r.submodulePath("fest"), mode.Name)
	campTag = latestTagForMode(r.submodulePath("camp"), mode.Name)
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
		return "", "", errors.New("missing component tags")
	}
	return festTag, campTag, nil
}

func checkModuleResolutionForDir(dir string, label string) error {
	modCacheDir, err := os.MkdirTemp("", "festival-module-resolution-gomodcache-")
	if err != nil {
		return fmt.Errorf("create %s module cache: %w", label, err)
	}
	defer os.RemoveAll(modCacheDir)

	goCacheDir, err := os.MkdirTemp("", "festival-module-resolution-gocache-")
	if err != nil {
		return fmt.Errorf("create %s build cache: %w", label, err)
	}
	defer os.RemoveAll(goCacheDir)

	env := map[string]string{
		"GOWORK":     "off",
		"GOMODCACHE": modCacheDir,
		"GOCACHE":    goCacheDir,
	}
	if _, err := cmdOutput(dir, env, "go", "mod", "download"); err != nil {
		return fmt.Errorf("%s module graph does not resolve from a clean cache: %w", label, err)
	}

	return nil
}

func extractTarFile(src, dst string) error {
	file, err := os.Open(src)
	if err != nil {
		return fmt.Errorf("open tar %s: %w", src, err)
	}
	defer file.Close()

	reader := tar.NewReader(file)
	for {
		header, err := reader.Next()
		if errors.Is(err, io.EOF) {
			return nil
		}
		if err != nil {
			return fmt.Errorf("read tar %s: %w", src, err)
		}

		target := filepath.Join(dst, header.Name)
		switch header.Typeflag {
		case tar.TypeXGlobalHeader, tar.TypeXHeader:
			continue
		case tar.TypeDir:
			if err := os.MkdirAll(target, 0o755); err != nil {
				return fmt.Errorf("create dir %s: %w", target, err)
			}
		case tar.TypeReg:
			if err := os.MkdirAll(filepath.Dir(target), 0o755); err != nil {
				return fmt.Errorf("create parent dir for %s: %w", target, err)
			}
			out, err := os.OpenFile(target, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, os.FileMode(header.Mode))
			if err != nil {
				return fmt.Errorf("open file %s: %w", target, err)
			}
			if _, err := io.Copy(out, reader); err != nil {
				out.Close()
				return fmt.Errorf("write file %s: %w", target, err)
			}
			if err := out.Close(); err != nil {
				return fmt.Errorf("close file %s: %w", target, err)
			}
		default:
			return fmt.Errorf("unsupported tar entry %s of type %d", header.Name, header.Typeflag)
		}
	}
}

func (r *repoContext) checkBundledModuleResolution(name string) error {
	tag, err := r.exactTag(name)
	if err != nil {
		return err
	}
	if tag == "" {
		tag = "HEAD"
	}
	return checkModuleResolutionForDir(r.submodulePath(name), fmt.Sprintf("%s %s", name, tag))
}

func (r *repoContext) checkBundledModuleResolutionAtTag(name, tag string) error {
	if strings.TrimSpace(tag) == "" {
		return fmt.Errorf("%s tag is empty", name)
	}

	stageDir, err := os.MkdirTemp("", "festival-"+name+"-tag-*")
	if err != nil {
		return fmt.Errorf("create %s tag staging dir: %w", name, err)
	}
	defer os.RemoveAll(stageDir)

	archivePath := filepath.Join(stageDir, "source.tar")
	if err := runCmd(r.submodulePath(name), nil, "git", "archive", "--format=tar", "-o", archivePath, tag); err != nil {
		return fmt.Errorf("archive %s %s: %w", name, tag, err)
	}

	sourceDir := filepath.Join(stageDir, "source")
	if err := os.MkdirAll(sourceDir, 0o755); err != nil {
		return fmt.Errorf("create source dir for %s %s: %w", name, tag, err)
	}
	if err := extractTarFile(archivePath, sourceDir); err != nil {
		return fmt.Errorf("extract %s %s: %w", name, tag, err)
	}

	return checkModuleResolutionForDir(sourceDir, fmt.Sprintf("%s %s", name, tag))
}

func (r *repoContext) exactTag(name string) (string, error) {
	out, err := cmdOutput(r.submodulePath(name), nil, "git", "describe", "--tags", "--exact-match", "HEAD")
	if err != nil {
		return "", nil
	}
	return strings.TrimSpace(out), nil
}

func (r *repoContext) exactComponentTags() (string, string, error) {
	festTag, err := r.exactTag("fest")
	if err != nil {
		return "", "", err
	}
	campTag, err := r.exactTag("camp")
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

func (r *repoContext) commitPinnedArtifacts(festTag, campTag string) error {
	hasDiff, err := r.cachedDiffExists("fest", "camp", "docs/cli-reference")
	if err != nil {
		return err
	}
	if !hasDiff {
		fmt.Printf("Submodule pointers and docs already at fest=%s, camp=%s; no release commit needed.\n", festTag, campTag)
		return nil
	}
	if err := r.runGit("commit", "-m", fmt.Sprintf("Release: pin fest %s and camp %s", festTag, campTag)); err != nil {
		return err
	}
	return r.runGit("push", "origin", "HEAD")
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

func (r *repoContext) pinFromLatest(modeName string) error {
	if err := r.ensureAllWorktreesClean(); err != nil {
		return err
	}
	if err := r.fetchReleaseRefs(); err != nil {
		return err
	}
	festTag, campTag, err := r.latestComponentTags(modeName)
	if err != nil {
		return err
	}

	if err := r.checkoutSubmoduleTag("fest", festTag); err != nil {
		return err
	}
	if err := r.checkoutSubmoduleTag("camp", campTag); err != nil {
		return err
	}
	if err := r.stageSubmoduleRefs(); err != nil {
		return err
	}

	fmt.Printf("Pinned fest to: %s\n", festTag)
	fmt.Printf("Pinned camp to: %s\n", campTag)
	return nil
}

func (r *repoContext) currentStableReadiness() (stableReadinessReport, error) {
	report := stableReadinessReport{Ready: true}

	for _, sub := range submodules {
		tag, err := r.exactTag(sub)
		if err != nil {
			return stableReadinessReport{}, err
		}
		switch {
		case tag == "":
			report.Ready = false
			report.Issues = append(report.Issues, fmt.Sprintf("%s is not pinned to an exact tag", sub))
		case !operator.TagMatchesMode(tag, "stable"):
			report.Ready = false
			report.Issues = append(report.Issues, fmt.Sprintf("%s is pinned to non-stable tag %s", sub, tag))
		default:
			if err := r.checkBundledModuleResolution(sub); err != nil {
				report.Ready = false
				report.Issues = append(report.Issues, err.Error())
			}
		}
	}

	return report, nil
}

func (r *repoContext) ensureStableTagCandidateReady(name, tag string) error {
	if !operator.TagMatchesMode(tag, "stable") {
		return fmt.Errorf("%s candidate %s is not a stable tag", name, tag)
	}
	return r.checkBundledModuleResolutionAtTag(name, tag)
}

func (r *repoContext) ensureStableLatestBundleReady() error {
	if err := r.fetchReleaseRefs(); err != nil {
		return err
	}
	festTag, campTag, err := r.latestComponentTags("stable")
	if err != nil {
		return err
	}
	if err := r.ensureStableTagCandidateReady("fest", festTag); err != nil {
		return err
	}
	if err := r.ensureStableTagCandidateReady("camp", campTag); err != nil {
		return err
	}
	return nil
}

func (r *repoContext) ensureCurrentComponentsResolveForStableTagging() error {
	for _, sub := range submodules {
		if err := checkModuleResolutionForDir(r.submodulePath(sub), fmt.Sprintf("%s HEAD", sub)); err != nil {
			return err
		}
	}
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
	readiness, err := ctx.currentStableReadiness()
	if err != nil {
		return err
	}
	if readiness.Ready {
		fmt.Println("Stable release readiness: ready")
	} else {
		fmt.Println("Stable release readiness: blocked")
		for _, issue := range readiness.Issues {
			fmt.Printf("  - %s\n", issue)
		}
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
	fmt.Println("  One-command: just release dev | just release rc | just release stable")
	fmt.Println("  Manual:      just release draft <version> | draft-rc <version> <n> | draft-dev <version> <n>")
	return nil
}

func runDraftFromLatest(ctx *repoContext, version string, mode releaseMode, iteration int) error {
	releaseTag := releaseTagFor(mode, version, iteration)
	if err := ctx.ensureTagAbsent(releaseTag); err != nil {
		return err
	}
	if mode.Name == "stable" {
		if err := ctx.ensureStableLatestBundleReady(); err != nil {
			return err
		}
	}
	if err := ctx.pinFromLatest(mode.Name); err != nil {
		return err
	}
	if err := ctx.runDocs(mode); err != nil {
		return err
	}
	if err := ctx.stageReleaseArtifacts(); err != nil {
		return err
	}

	festTag, campTag, err := ctx.exactComponentTags()
	if err != nil {
		return err
	}
	if !operator.TagMatchesMode(festTag, mode.Name) || !operator.TagMatchesMode(campTag, mode.Name) {
		return fmt.Errorf("submodules are not pinned to exact %s tags after refresh", mode.Name)
	}

	if err := ctx.commitPinnedArtifacts(festTag, campTag); err != nil {
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
	if err := ctx.ensureAllWorktreesClean(); err != nil {
		return err
	}
	if err := ctx.ensureCurrentComponentsResolveForStableTagging(); err != nil {
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
	if err := ctx.commitPinnedArtifacts(festTag, campTag); err != nil {
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

func runBundleWithRoot(repoRoot, channel string) error {
	ctx, err := newRepoContext(repoRoot)
	if err != nil {
		return err
	}

	state, err := collectState(ctx.Root, channel)
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
	fmt.Printf("  fest tag: %s\n", state.FestTag)
	fmt.Printf("  camp tag: %s\n", state.CampTag)
	fmt.Println()
	fmt.Printf("== %s Bundle Release ==\n", strings.ToUpper(channel))
	fmt.Println(plan.Description)
	fmt.Printf("Using latest already-created %s tags from camp and fest.\n", channel)
	fmt.Println()

	return runDraftFromLatest(ctx, plan.Version, mode, plan.Iteration)
}

func runCleanup(ctx *repoContext, tag string) error {
	fmt.Printf("Deleting GitHub release %s...\n", tag)
	if err := runCmd(ctx.Root, nil, "gh", "release", "delete", tag, "--repo", "Obedience-Corp/festival", "--yes"); err != nil {
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
	out, err := cmdOutput(dir, nil, "gh", "secret", "list", "--repo", "Obedience-Corp/festival")
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
