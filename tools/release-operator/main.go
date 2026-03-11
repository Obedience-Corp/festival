package main

import (
	"errors"
	"fmt"
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
	if len(args) < 2 || args[0] != "bundle" {
		return errors.New("usage: release-operator bundle <dev|rc|stable> [--repo-root PATH]")
	}

	channel := args[1]
	repoRoot, err := parseRepoRoot(args[2:])
	if err != nil {
		return err
	}

	repoRoot, err = filepath.Abs(repoRoot)
	if err != nil {
		return fmt.Errorf("resolve repo root: %w", err)
	}

	state, err := collectState(repoRoot, channel)
	if err != nil {
		return err
	}

	plan, err := operator.DeriveBundlePlan(state)
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

	return runJust(repoRoot, plan.DraftRecipe, plan.DraftArgs...)
}

func parseRepoRoot(args []string) (string, error) {
	repoRoot := "."
	for i := 0; i < len(args); i++ {
		if args[i] == "--repo-root" {
			if i+1 >= len(args) {
				return "", errors.New("missing value for --repo-root")
			}
			repoRoot = args[i+1]
			i++
		}
	}
	return repoRoot, nil
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

	for _, sub := range []string{"fest", "camp"} {
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
		Channel:              channel,
		CurrentBranch:        branch,
		FestTag:              latestTagForMode(filepath.Join(repoRoot, "fest"), channel),
		CampTag:              latestTagForMode(filepath.Join(repoRoot, "camp"), channel),
		LatestFestivalDev:    latestTagForMode(repoRoot, "dev"),
		LatestFestivalStable: latestTagForMode(repoRoot, "stable"),
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
	return runCmd(dir, "git", "fetch", "--tags")
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

func runJust(repoRoot, recipe string, args ...string) error {
	justfile := filepath.Join(repoRoot, ".justfiles", "release.just")
	cmdArgs := []string{"--justfile", justfile, recipe}
	cmdArgs = append(cmdArgs, args...)
	return runCmd(repoRoot, "just", cmdArgs...)
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
	cmdArgs := append([]string{}, args...)
	out, err := cmdOutput(dir, "git", cmdArgs...)
	if err != nil {
		return "", fmt.Errorf("git %s: %w", strings.Join(args, " "), err)
	}
	return strings.TrimSpace(out), nil
}

func cmdOutput(dir, name string, args ...string) (string, error) {
	cmd := exec.Command(name, args...)
	cmd.Dir = dir
	out, err := cmd.CombinedOutput()
	if err != nil {
		return "", fmt.Errorf("%v\n%s", err, strings.TrimSpace(string(out)))
	}
	return string(out), nil
}

func runCmd(dir, name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Dir = dir
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}
