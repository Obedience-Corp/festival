package main

import (
	"errors"
	"flag"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"

	"github.com/Obedience-Corp/festival/tools/release-operator/internal/operator"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintln(os.Stderr, "ERROR:", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) == 0 {
		printHelp(os.Stdout)
		return nil
	}

	switch args[0] {
	case "help", "--help", "-h":
		printHelp(os.Stdout)
		return nil
	case "bundle":
		opts, err := parseBundleArgs(args[1:])
		if err != nil {
			return err
		}
		return runBundleWithRoot(opts)
	case "plan":
		opts, err := parsePlanArgs(args[1:])
		if err != nil {
			return err
		}
		return runPlanWithRoot(opts)
	case "pin":
		fs := commandFlags("pin")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev (a mode=... prefix is also accepted)")
		festTag := fs.String("fest-tag", "latest", "fest tag selector: latest, keep, or an explicit tag (a fest=... prefix is also accepted)")
		campTag := fs.String("camp-tag", "latest", "camp tag selector: latest, keep, or an explicit tag (a camp=... prefix is also accepted)")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		return ctx.pinFromLatest(
			normalizeOptionalAssignment(*modeName, "mode"),
			normalizeOptionalAssignment(*festTag, "fest"),
			normalizeOptionalAssignment(*campTag, "camp"),
		)
	case "status":
		ctx, err := repoContextFromArgs("status", args[1:])
		if err != nil {
			return err
		}
		return runStatus(ctx)
	case "preflight":
		fs := commandFlags("preflight")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev (a mode=... prefix is also accepted)")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		mode, err := modeConfig(normalizeOptionalAssignment(*modeName, "mode"))
		if err != nil {
			return err
		}
		return runPreflight(ctx, mode)
	case "require-stable-publish-credentials":
		ctx, err := repoContextFromArgs("require-stable-publish-credentials", args[1:])
		if err != nil {
			return err
		}
		return runRequireStablePublishCredentials(ctx)
	case "check-bundled-modules":
		ctx, err := repoContextFromArgs("check-bundled-modules", args[1:])
		if err != nil {
			return err
		}
		return runCheckBundledModules(ctx)
	case "draft-from-latest":
		fs := commandFlags("draft-from-latest")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		version := fs.String("version", "", "festival release version without leading v")
		modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev (a mode=... prefix is also accepted)")
		iteration := fs.Int("n", 1, "prerelease iteration for rc/dev flows")
		festTag := fs.String("fest-tag", "latest", "fest tag selector: latest, keep, or an explicit tag (a fest=... prefix is also accepted)")
		campTag := fs.String("camp-tag", "latest", "camp tag selector: latest, keep, or an explicit tag (a camp=... prefix is also accepted)")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		if *version == "" {
			return errors.New("missing required --version")
		}
		modeValue := normalizeOptionalAssignment(*modeName, "mode")
		festValue := normalizeOptionalAssignment(*festTag, "fest")
		campValue := normalizeOptionalAssignment(*campTag, "camp")
		mode, err := modeConfig(modeValue)
		if err != nil {
			return err
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		state, err := collectState(ctx.Root, mode.Name, festValue, campValue)
		if err != nil {
			return err
		}
		return runDraftFromLatest(ctx, *version, mode, *iteration, festValue, campValue, state.CurrentPinnedFestTag, state.CurrentPinnedCampTag)
	case "draft-bootstrap":
		fs := commandFlags("draft-bootstrap")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		version := fs.String("version", "", "festival release version without leading v")
		festVersion := fs.String("fest-version", "", "fest release version without leading v")
		campVersion := fs.String("camp-version", "", "camp release version without leading v")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		if *version == "" || *festVersion == "" || *campVersion == "" {
			return errors.New("draft-bootstrap requires --version, --fest-version, and --camp-version")
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		return runDraftBootstrap(ctx, *version, *festVersion, *campVersion)
	case "draft":
		return runDraftCommand(args[1:], "stable")
	case "draft-rc":
		return runDraftCommand(args[1:], "rc")
	case "draft-dev":
		return runDraftCommand(args[1:], "dev")
	case "cleanup":
		fs := commandFlags("cleanup")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		tag := fs.String("tag", "", "full tag name to delete")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		if *tag == "" {
			return errors.New("missing required --tag")
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		return runCleanup(ctx, *tag)
	case "emit-marketplace-entry":
		fs := commandFlags("emit-marketplace-entry")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		tag := fs.String("tag", "", "release tag, e.g. v0.2.10 (required)")
		channel := fs.String("channel", "stable", "release channel")
		checksums := fs.String("checksums", "dist/checksums.txt", "path to checksums.txt")
		output := fs.String("output", "dist/marketplace/obey-package.json", "output path for the generated product manifest")
		publishedAt := fs.String("published-at", "", "RFC3339 published timestamp (optional)")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		if *tag == "" {
			return errors.New("missing required --tag")
		}
		return runEmitMarketplaceEntry(*repoRoot, *tag, *channel, *checksums, *output, *publishedAt)
	default:
		return fmt.Errorf("unknown command %q", args[0])
	}
}

func runEmitMarketplaceEntry(repoRoot, tag, channel, checksumsPath, outputPath, publishedAt string) error {
	festTag, err := exactTagAt(filepath.Join(repoRoot, "fest"))
	if err != nil {
		return fmt.Errorf("resolve fest tag: %w", err)
	}
	campTag, err := exactTagAt(filepath.Join(repoRoot, "camp"))
	if err != nil {
		return fmt.Errorf("resolve camp tag: %w", err)
	}
	if festTag == "" || campTag == "" {
		return fmt.Errorf("fest/camp submodules are not pinned to exact tags (fest=%q camp=%q)", festTag, campTag)
	}

	checksumsAbs := checksumsPath
	if !filepath.IsAbs(checksumsAbs) {
		checksumsAbs = filepath.Join(repoRoot, checksumsPath)
	}
	arts, err := suiteArtifactsFromChecksums(checksumsAbs, tag)
	if err != nil {
		return err
	}

	out, err := operator.BuildMarketplaceEntry(operator.MarketplaceEntryInput{
		FestivalVersion: strings.TrimPrefix(tag, "v"),
		Channel:         channel,
		PublishedAt:     publishedAt,
		CampVersion:     strings.TrimPrefix(campTag, "v"),
		FestVersion:     strings.TrimPrefix(festTag, "v"),
		Artifacts:       arts,
	})
	if err != nil {
		return err
	}

	outAbs := outputPath
	if !filepath.IsAbs(outAbs) {
		outAbs = filepath.Join(repoRoot, outputPath)
	}
	if err := os.MkdirAll(filepath.Dir(outAbs), 0o755); err != nil {
		return fmt.Errorf("create output dir: %w", err)
	}
	if err := os.WriteFile(outAbs, out, 0o644); err != nil {
		return fmt.Errorf("write %s: %w", outAbs, err)
	}
	fmt.Printf("wrote %s (%d bytes)\n", outAbs, len(out))
	return nil
}

func suiteArtifactsFromChecksums(path, tag string) ([]operator.ArtifactInput, error) {
	data, err := os.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("read checksums: %w", err)
	}
	platform := map[string][2]string{
		"macOS-all.tar.gz":    {"darwin", "all"},
		"linux-x86_64.tar.gz": {"linux", "amd64"},
		"linux-arm64.tar.gz":  {"linux", "arm64"},
	}
	var arts []operator.ArtifactInput
	for _, line := range strings.Split(strings.TrimSpace(string(data)), "\n") {
		fields := strings.Fields(line)
		if len(fields) != 2 {
			continue
		}
		sum, name := fields[0], fields[1]
		for suffix, osarch := range platform {
			if strings.HasSuffix(name, suffix) {
				arts = append(arts, operator.ArtifactInput{
					OS:       osarch[0],
					Arch:     osarch[1],
					Filename: name,
					URL:      fmt.Sprintf("https://github.com/Obedience-Corp/festival/releases/download/%s/%s", tag, name),
					SHA256:   sum,
				})
			}
		}
	}
	if len(arts) != 3 {
		return nil, fmt.Errorf("expected 3 suite artifacts in %s, found %d", path, len(arts))
	}
	return arts, nil
}

func runDraftCommand(args []string, modeName string) error {
	fs := commandFlags("draft")
	repoRoot := fs.String("repo-root", ".", "festival repo root")
	version := fs.String("version", "", "festival release version without leading v")
	iteration := fs.Int("n", 1, "prerelease iteration for rc/dev flows")
	if err := fs.Parse(args); err != nil {
		return err
	}
	if *version == "" {
		return errors.New("missing required --version")
	}
	ctx, err := newRepoContext(*repoRoot)
	if err != nil {
		return err
	}
	mode, err := modeConfig(modeName)
	if err != nil {
		return err
	}
	return runDraftExplicit(ctx, *version, mode, *iteration)
}

func commandFlags(name string) *flag.FlagSet {
	fs := flag.NewFlagSet(name, flag.ContinueOnError)
	fs.SetOutput(os.Stderr)
	return fs
}

func normalizeOptionalAssignment(value, key string) string {
	value = strings.TrimSpace(value)
	prefix := key + "="
	if strings.HasPrefix(value, prefix) {
		return strings.TrimSpace(strings.TrimPrefix(value, prefix))
	}
	return value
}

type bundleOptions struct {
	RepoRoot     string
	Channel      string
	FestSelector string
	CampSelector string
}

type planOptions struct {
	RepoRoot     string
	Channel      string
	FestSelector string
	CampSelector string
}

func parseBundleArgs(args []string) (bundleOptions, error) {
	fs := commandFlags("bundle")
	repoRootFlag := fs.String("repo-root", ".", "festival repo root")
	festTag := fs.String("fest-tag", "latest", "fest tag selector: latest, keep, or an explicit tag (a fest=... prefix is also accepted)")
	campTag := fs.String("camp-tag", "latest", "camp tag selector: latest, keep, or an explicit tag (a camp=... prefix is also accepted)")
	if err := fs.Parse(args); err != nil {
		return bundleOptions{}, err
	}
	if fs.NArg() != 1 {
		return bundleOptions{}, errors.New("usage: release-operator bundle <dev|rc|stable> [--repo-root PATH] [--fest-tag latest|keep|vX.Y.Z] [--camp-tag latest|keep|vX.Y.Z]")
	}
	return bundleOptions{
		RepoRoot:     *repoRootFlag,
		Channel:      fs.Arg(0),
		FestSelector: normalizeOptionalAssignment(*festTag, "fest"),
		CampSelector: normalizeOptionalAssignment(*campTag, "camp"),
	}, nil
}

func parsePlanArgs(args []string) (planOptions, error) {
	fs := commandFlags("plan")
	repoRootFlag := fs.String("repo-root", ".", "festival repo root")
	modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev (a mode=... prefix is also accepted)")
	festTag := fs.String("fest-tag", "latest", "fest tag selector: latest, keep, or an explicit tag (a fest=... prefix is also accepted)")
	campTag := fs.String("camp-tag", "latest", "camp tag selector: latest, keep, or an explicit tag (a camp=... prefix is also accepted)")
	if err := fs.Parse(args); err != nil {
		return planOptions{}, err
	}
	if fs.NArg() != 0 {
		return planOptions{}, errors.New("usage: release-operator plan [--mode stable|rc|dev] [--repo-root PATH] [--fest-tag latest|keep|vX.Y.Z] [--camp-tag latest|keep|vX.Y.Z]")
	}
	return planOptions{
		RepoRoot:     *repoRootFlag,
		Channel:      normalizeOptionalAssignment(*modeName, "mode"),
		FestSelector: normalizeOptionalAssignment(*festTag, "fest"),
		CampSelector: normalizeOptionalAssignment(*campTag, "camp"),
	}, nil
}

func repoContextFromArgs(name string, args []string) (*repoContext, error) {
	fs := commandFlags(name)
	repoRoot := fs.String("repo-root", ".", "festival repo root")
	if err := fs.Parse(args); err != nil {
		return nil, err
	}
	if fs.NArg() != 0 {
		return nil, fmt.Errorf("%s does not accept positional arguments", name)
	}
	return newRepoContext(*repoRoot)
}

func printHelp(out io.Writer) {
	fmt.Fprintln(out, "festival release commands")
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Primary:")
	fmt.Fprintln(out, "  just release plan [mode=stable] [fest=latest|keep|vX.Y.Z] [camp=latest|keep|vX.Y.Z]")
	fmt.Fprintln(out, "  just release dev [fest=latest|keep|vX.Y.Z] [camp=latest|keep|vX.Y.Z]")
	fmt.Fprintln(out, "  just release rc [fest=latest|keep|vX.Y.Z] [camp=latest|keep|vX.Y.Z]")
	fmt.Fprintln(out, "  just release stable [fest=latest|keep|vX.Y.Z] [camp=latest|keep|vX.Y.Z]")
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Support:")
	fmt.Fprintln(out, "  just release status")
	fmt.Fprintln(out, "  just release preflight [stable|rc|dev]")
	fmt.Fprintln(out, "  just test bundled-module-resolution")
	fmt.Fprintln(out, "  just release dry-run")
	fmt.Fprintln(out, "  just release cleanup <tag>")
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Stable releases on main:")
	fmt.Fprintln(out, "  main is PR-only, so the stable pin commit ships through a transient")
	fmt.Fprintln(out, "  release-pin/<tag> branch that is auto-created and squash-merged.")
	fmt.Fprintln(out, "  The active gh account needs push access to Obedience-Corp/festival.")
	fmt.Fprintln(out, "  The main ruleset requires a PR with 0 approvals and no status checks,")
	fmt.Fprintln(out, "  so a push-capable account merges immediately (no --admin bypass needed).")
	fmt.Fprintln(out, "  If a run fails after the PR is created, rerun the same command to continue.")
}

func collectState(repoRoot, channel, festSelector, campSelector string) (operator.BundleInput, error) {
	if channel != "dev" && channel != "rc" && channel != "stable" {
		return operator.BundleInput{}, fmt.Errorf("channel must be dev, rc, or stable (got %q)", channel)
	}

	// Check the superproject's own worktree before ensureSubmodulesReady:
	// auto-initializing a submodule is itself a mutation, and a dirty root
	// should refuse before that mutation happens, not after.
	if dirty, err := worktreeDirty(repoRoot); err != nil {
		return operator.BundleInput{}, err
	} else if dirty {
		return operator.BundleInput{}, errors.New("festival repo has uncommitted changes")
	}

	if err := ensureSubmodulesReady(repoRoot); err != nil {
		return operator.BundleInput{}, err
	}

	for _, sub := range submodules {
		subPath := filepath.Join(repoRoot, sub)
		if dirty, err := worktreeDirty(subPath); err != nil {
			return operator.BundleInput{}, err
		} else if dirty {
			return operator.BundleInput{}, fmt.Errorf("%s has uncommitted changes", sub)
		}
	}

	if err := fetchTags(repoRoot); err != nil {
		return operator.BundleInput{}, err
	}
	if err := fetchTags(filepath.Join(repoRoot, "fest")); err != nil {
		return operator.BundleInput{}, err
	}
	if err := fetchTags(filepath.Join(repoRoot, "camp")); err != nil {
		return operator.BundleInput{}, err
	}

	branch, err := gitOutput(repoRoot, "rev-parse", "--abbrev-ref", "HEAD")
	if err != nil {
		return operator.BundleInput{}, err
	}

	currentFestTag, err := exactTagAtForMode(filepath.Join(repoRoot, "fest"), channel)
	if err != nil {
		return operator.BundleInput{}, err
	}
	currentCampTag, err := exactTagAtForMode(filepath.Join(repoRoot, "camp"), channel)
	if err != nil {
		return operator.BundleInput{}, err
	}

	selectedFestTag, err := resolveSelectedTag(filepath.Join(repoRoot, "fest"), channel, festSelector)
	if err != nil {
		return operator.BundleInput{}, err
	}
	selectedCampTag, err := resolveSelectedTag(filepath.Join(repoRoot, "camp"), channel, campSelector)
	if err != nil {
		return operator.BundleInput{}, err
	}

	state := operator.BundleInput{
		Channel:              channel,
		CurrentBranch:        branch,
		FestTag:              selectedFestTag,
		CampTag:              selectedCampTag,
		CurrentPinnedFestTag: currentFestTag,
		CurrentPinnedCampTag: currentCampTag,
	}
	state.LatestFestivalDev, err = latestReachableTagForMode(repoRoot, "dev")
	if err != nil {
		return operator.BundleInput{}, err
	}
	state.LatestFestivalStable, err = latestReachableTagForMode(repoRoot, "stable")
	if err != nil {
		return operator.BundleInput{}, err
	}
	state.LatestFestivalPromotableRC, err = latestReachableTagForMode(repoRoot, "rc")
	if err != nil {
		return operator.BundleInput{}, err
	}

	if state.LatestFestivalDev != "" {
		match, err := headMatchesTag(repoRoot, state.LatestFestivalDev)
		if err != nil {
			return operator.BundleInput{}, err
		}
		state.CurrentCommitTaggedLatestDev = match
	}
	if state.LatestFestivalStable != "" {
		match, err := headMatchesTag(repoRoot, state.LatestFestivalStable)
		if err != nil {
			return operator.BundleInput{}, err
		}
		state.CurrentCommitTaggedLatestStable = match
	}

	if state.CurrentBranch != "" && strings.HasPrefix(state.CurrentBranch, "release/v") {
		version := strings.TrimPrefix(state.CurrentBranch, "release/v")
		state.LatestFestivalVersionRC = latestTagForModeVersion(repoRoot, "rc", version)
		if state.LatestFestivalVersionRC != "" {
			match, err := headMatchesTag(repoRoot, state.LatestFestivalVersionRC)
			if err != nil {
				return operator.BundleInput{}, err
			}
			state.CurrentCommitTaggedVersionRC = match
		}
	}

	return state, nil
}

// exactTagAt returns the newest tag pointing at HEAD in dir, or "" if HEAD is
// untagged. Uses `git tag --points-at HEAD` because it exits 0 with empty
// stdout for the untagged-HEAD case, avoiding locale- and version-dependent
// stderr parsing that `git describe --exact-match` would require.
func exactTagAt(dir string) (string, error) {
	tags, err := exactTagsAt(dir)
	if err != nil {
		return "", err
	}
	if len(tags) == 0 {
		return "", nil
	}
	return tags[0], nil
}

func exactTagAtForMode(dir, mode string) (string, error) {
	tags, err := exactTagsAt(dir)
	if err != nil {
		return "", err
	}
	for _, tag := range tags {
		if operator.TagMatchesMode(tag, mode) {
			return tag, nil
		}
	}
	return "", nil
}

func exactTagsAt(dir string) ([]string, error) {
	return gitLines(dir, "tag", "--points-at", "HEAD", "--sort=-v:refname")
}

func resolveSelectedTag(dir, mode, selector string) (string, error) {
	name := filepath.Base(dir)

	switch selector {
	case "", "latest":
		tag := latestTagForMode(dir, mode)
		if tag == "" {
			return "", fmt.Errorf("%s has no %s tag to select", name, mode)
		}
		return tag, nil
	case "keep":
		tag, err := exactTagAtForMode(dir, mode)
		if err != nil {
			return "", err
		}
		if tag == "" {
			return "", fmt.Errorf("%s is not pinned to an exact tag, so keep cannot be used", name)
		}
		if !operator.TagMatchesMode(tag, mode) {
			return "", fmt.Errorf("%s keep tag %s does not match %s mode", name, tag, mode)
		}
		return tag, nil
	default:
		if !operator.TagMatchesMode(selector, mode) {
			return "", fmt.Errorf("%s tag %s does not match %s mode", name, selector, mode)
		}
		out, err := gitOutput(dir, "tag", "-l", selector)
		if err != nil {
			return "", err
		}
		if strings.TrimSpace(out) == "" {
			return "", fmt.Errorf("%s tag %s was not found", name, selector)
		}
		return selector, nil
	}
}

func worktreeDirty(dir string) (bool, error) {
	out, err := gitOutput(dir, "status", "--porcelain")
	if err != nil {
		return false, err
	}
	return strings.TrimSpace(out) != "", nil
}

func fetchTags(dir string) error {
	return runCmd(dir, nil, "git", "fetch", "--tags")
}

func headMatchesTag(dir, tag string) (bool, error) {
	tagCommit, err := gitOutput(dir, "rev-list", "-n", "1", tag)
	if err != nil {
		return false, err
	}
	headCommit, err := gitOutput(dir, "rev-parse", "HEAD")
	if err != nil {
		return false, err
	}
	return tagCommit == headCommit, nil
}

func tagAncestorOfHead(dir, tag string) (bool, error) {
	tagCommit, err := gitOutput(dir, "rev-list", "-n", "1", tag)
	if err != nil {
		return false, err
	}
	cmd := exec.Command("git", "merge-base", "--is-ancestor", tagCommit, "HEAD")
	cmd.Dir = dir
	if err := cmd.Run(); err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 1 {
			return false, nil
		}
		return false, fmt.Errorf("git merge-base --is-ancestor: %w", err)
	}
	return true, nil
}

func latestTagForMode(dir, mode string) string {
	tags, err := gitLines(dir, "tag", "-l", "v*", "--sort=-v:refname")
	if err != nil {
		return ""
	}
	for _, tag := range tags {
		if operator.TagMatchesMode(tag, mode) {
			return tag
		}
	}
	return ""
}

func latestReachableTagForMode(dir, mode string) (string, error) {
	tags, err := gitLines(dir, "tag", "-l", "v*", "--sort=-v:refname")
	if err != nil {
		return "", err
	}
	for _, tag := range tags {
		if !operator.TagMatchesMode(tag, mode) {
			continue
		}
		ancestor, err := tagAncestorOfHead(dir, tag)
		if err != nil {
			return "", err
		}
		if ancestor {
			return tag, nil
		}
	}
	return "", nil
}

func latestTagForModeVersion(dir, mode, version string) string {
	tags, err := gitLines(dir, "tag", "-l", "v*", "--sort=-v:refname")
	if err != nil {
		return ""
	}
	for _, tag := range tags {
		if operator.TagMatchesModeVersion(tag, mode, version) {
			return tag
		}
	}
	return ""
}

func gitLines(dir string, args ...string) ([]string, error) {
	out, err := gitOutput(dir, args...)
	if err != nil {
		return nil, err
	}
	if strings.TrimSpace(out) == "" {
		return nil, nil
	}
	return strings.Split(strings.TrimSpace(out), "\n"), nil
}

func gitOutput(dir string, args ...string) (string, error) {
	out, err := cmdOutput(dir, nil, "git", args...)
	if err != nil {
		return "", fmt.Errorf("git %s: %w", strings.Join(args, " "), err)
	}
	return strings.TrimSpace(out), nil
}

func cmdOutput(dir string, env map[string]string, name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	cmd.Dir = dir
	if envList := envList(env); len(envList) > 0 {
		cmd.Env = envList
	}
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("%v\n%s", err, strings.TrimSpace(string(out)))
	}
	return string(out), nil
}

func runCmd(dir string, env map[string]string, name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Dir = dir
	if envList := envList(env); len(envList) > 0 {
		cmd.Env = envList
	}
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
