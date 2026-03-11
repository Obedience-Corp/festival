package main

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

func TestLatestReachableTagForModeIgnoresOffBranchTags(t *testing.T) {
	repo := initTestRepo(t)

	runGit(t, repo, "checkout", "-b", "develop")
	writeFile(t, filepath.Join(repo, "develop.txt"), "develop\n")
	runGit(t, repo, "add", "develop.txt")
	runGit(t, repo, "commit", "-m", "develop commit")
	runGit(t, repo, "tag", "v0.1.1-dev.1")

	runGit(t, repo, "checkout", "main")
	writeFile(t, filepath.Join(repo, "main.txt"), "main\n")
	runGit(t, repo, "add", "main.txt")
	runGit(t, repo, "commit", "-m", "main commit")
	runGit(t, repo, "tag", "v0.2.0")

	runGit(t, repo, "checkout", "-b", "feature/dev-line")
	writeFile(t, filepath.Join(repo, "feature.txt"), "feature\n")
	runGit(t, repo, "add", "feature.txt")
	runGit(t, repo, "commit", "-m", "feature dev commit")
	runGit(t, repo, "tag", "v0.2.1-dev.9")

	runGit(t, repo, "checkout", "develop")

	devTag, err := latestReachableTagForMode(repo, "dev")
	if err != nil {
		t.Fatalf("latestReachableTagForMode(dev) returned error: %v", err)
	}
	if got, want := devTag, "v0.1.1-dev.1"; got != want {
		t.Fatalf("latestReachableTagForMode(dev) = %q, want %q", got, want)
	}

	stableTag, err := latestReachableTagForMode(repo, "stable")
	if err != nil {
		t.Fatalf("latestReachableTagForMode(stable) returned error: %v", err)
	}
	if got, want := stableTag, "v0.1.0"; got != want {
		t.Fatalf("latestReachableTagForMode(stable) = %q, want %q", got, want)
	}

	if got, want := latestTagForMode(repo, "dev"), "v0.2.1-dev.9"; got != want {
		t.Fatalf("latestTagForMode(dev) = %q, want %q", got, want)
	}
	if got, want := latestTagForMode(repo, "stable"), "v0.2.0"; got != want {
		t.Fatalf("latestTagForMode(stable) = %q, want %q", got, want)
	}
}

func initTestRepo(t *testing.T) string {
	t.Helper()

	repo := t.TempDir()
	runGit(t, repo, "init", "-b", "main")
	runGit(t, repo, "config", "user.name", "Test User")
	runGit(t, repo, "config", "user.email", "test@example.com")

	writeFile(t, filepath.Join(repo, "README.md"), "test\n")
	runGit(t, repo, "add", "README.md")
	runGit(t, repo, "commit", "-m", "initial commit")
	runGit(t, repo, "tag", "v0.1.0")

	return repo
}

func writeFile(t *testing.T, path, content string) {
	t.Helper()
	if err := os.WriteFile(path, []byte(content), 0o644); err != nil {
		t.Fatalf("write %s: %v", path, err)
	}
}

func runGit(t *testing.T, dir string, args ...string) {
	t.Helper()

	cmd := exec.Command("git", args...)
	cmd.Dir = dir
	out, err := cmd.CombinedOutput()
	if err != nil {
		t.Fatalf("git %v failed: %v\n%s", args, err, out)
	}
}
