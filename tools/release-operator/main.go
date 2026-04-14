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
		fs := commandFlags("bundle")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		if fs.NArg() != 1 {
			return errors.New("usage: release-operator bundle <dev|rc|stable> [--repo-root PATH]")
		}
		return runBundleWithRoot(*repoRoot, fs.Arg(0))
	case "pin":
		fs := commandFlags("pin")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		return ctx.pinFromLatest(*modeName)
	case "status":
		ctx, err := repoContextFromArgs("status", args[1:])
		if err != nil {
			return err
		}
		return runStatus(ctx)
	case "preflight":
		fs := commandFlags("preflight")
		repoRoot := fs.String("repo-root", ".", "festival repo root")
		modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		mode, err := modeConfig(*modeName)
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
		modeName := fs.String("mode", "stable", "release mode: stable, rc, or dev")
		iteration := fs.Int("n", 1, "prerelease iteration for rc/dev flows")
		if err := fs.Parse(args[1:]); err != nil {
			return err
		}
		if *version == "" {
			return errors.New("missing required --version")
		}
		mode, err := modeConfig(*modeName)
		if err != nil {
			return err
		}
		ctx, err := newRepoContext(*repoRoot)
		if err != nil {
			return err
		}
		return runDraftFromLatest(ctx, *version, mode, *iteration)
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
	default:
		return fmt.Errorf("unknown command %q", args[0])
	}
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
	fmt.Fprintln(out, "  just release dev")
	fmt.Fprintln(out, "  just release rc")
	fmt.Fprintln(out, "  just release stable")
	fmt.Fprintln(out)
	fmt.Fprintln(out, "Support:")
	fmt.Fprintln(out, "  just release status")
	fmt.Fprintln(out, "  just release preflight [stable|rc|dev]")
	fmt.Fprintln(out, "  just test bundled-module-resolution")
	fmt.Fprintln(out, "  just release dry-run")
	fmt.Fprintln(out, "  just release cleanup <tag>")
}

func collectState(repoRoot, channel string) (operator.BundleInput, error) {
	if channel != "dev" && channel != "rc" && channel != "stable" {
		return operator.BundleInput{}, fmt.Errorf("channel must be dev, rc, or stable (got %q)", channel)
	}

	if dirty, err := worktreeDirty(repoRoot); err != nil {
		return operator.BundleInput{}, err
	} else if dirty {
		return operator.BundleInput{}, errors.New("festival repo has uncommitted changes")
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

	state := operator.BundleInput{
		Channel:       channel,
		CurrentBranch: branch,
		FestTag:       latestTagForMode(filepath.Join(repoRoot, "fest"), channel),
		CampTag:       latestTagForMode(filepath.Join(repoRoot, "camp"), channel),
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
