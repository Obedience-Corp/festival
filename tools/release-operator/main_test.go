package main

import (
	"os"
	"os/exec"
	"path/filepath"
	"testing"
)

func TestParseBundleArgsAcceptsRepoRootBeforeChannel(t *testing.T) {
	opts, err := parseBundleArgs([]string{"--repo-root", "/tmp/festival", "--fest-tag", "keep", "dev"})
	if err != nil {
		t.Fatalf("parseBundleArgs returned error: %v", err)
	}

	if got, want := opts.RepoRoot, "/tmp/festival"; got != want {
		t.Fatalf("repoRoot = %q, want %q", got, want)
	}
	if got, want := opts.Channel, "dev"; got != want {
		t.Fatalf("channel = %q, want %q", got, want)
	}
	if got, want := opts.FestSelector, "keep"; got != want {
		t.Fatalf("fest selector = %q, want %q", got, want)
	}
	if got, want := opts.CampSelector, "latest"; got != want {
		t.Fatalf("camp selector = %q, want %q", got, want)
	}
}

func TestParsePlanArgsAcceptsSelectors(t *testing.T) {
	opts, err := parsePlanArgs([]string{"--mode", "stable", "--fest-tag", "v0.2.4", "--camp-tag", "keep"})
	if err != nil {
		t.Fatalf("parsePlanArgs returned error: %v", err)
	}

	if got, want := opts.Channel, "stable"; got != want {
		t.Fatalf("channel = %q, want %q", got, want)
	}
	if got, want := opts.FestSelector, "v0.2.4"; got != want {
		t.Fatalf("fest selector = %q, want %q", got, want)
	}
	if got, want := opts.CampSelector, "keep"; got != want {
		t.Fatalf("camp selector = %q, want %q", got, want)
	}
}

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

func TestResolveSelectedTag(t *testing.T) {
	t.Run("selects latest keep and explicit tags", func(t *testing.T) {
		repo := initTestRepo(t)

		writeFile(t, filepath.Join(repo, "CHANGELOG.md"), "stable\n")
		runGit(t, repo, "add", "CHANGELOG.md")
		runGit(t, repo, "commit", "-m", "stable release")
		runGit(t, repo, "tag", "v0.2.0")

		if got, err := resolveSelectedTag(repo, "stable", "latest"); err != nil {
			t.Fatalf("resolveSelectedTag(latest) error = %v", err)
		} else if want := "v0.2.0"; got != want {
			t.Fatalf("resolveSelectedTag(latest) = %q, want %q", got, want)
		}

		if got, err := resolveSelectedTag(repo, "stable", "keep"); err != nil {
			t.Fatalf("resolveSelectedTag(keep) error = %v", err)
		} else if want := "v0.2.0"; got != want {
			t.Fatalf("resolveSelectedTag(keep) = %q, want %q", got, want)
		}

		if got, err := resolveSelectedTag(repo, "stable", "v0.1.0"); err != nil {
			t.Fatalf("resolveSelectedTag(explicit) error = %v", err)
		} else if want := "v0.1.0"; got != want {
			t.Fatalf("resolveSelectedTag(explicit) = %q, want %q", got, want)
		}
	})

	t.Run("keep rejects untagged head", func(t *testing.T) {
		repo := initTestRepo(t)

		writeFile(t, filepath.Join(repo, "UNTAGGED.md"), "untagged\n")
		runGit(t, repo, "add", "UNTAGGED.md")
		runGit(t, repo, "commit", "-m", "untagged commit")

		if _, err := resolveSelectedTag(repo, "stable", "keep"); err == nil {
			t.Fatal("expected keep selection to fail on untagged HEAD")
		}
	})
}

func TestExactTagAt(t *testing.T) {
	t.Run("returns empty for untagged HEAD without error", func(t *testing.T) {
		repo := initTestRepo(t)
		writeFile(t, filepath.Join(repo, "untagged.md"), "untagged\n")
		runGit(t, repo, "add", "untagged.md")
		runGit(t, repo, "commit", "-m", "untagged")

		got, err := exactTagAt(repo)
		if err != nil {
			t.Fatalf("exactTagAt returned error for untagged HEAD: %v", err)
		}
		if got != "" {
			t.Fatalf("exactTagAt = %q, want empty string", got)
		}
	})

	t.Run("returns a tag when HEAD is tagged", func(t *testing.T) {
		repo := initTestRepo(t)
		got, err := exactTagAt(repo)
		if err != nil {
			t.Fatalf("exactTagAt returned error: %v", err)
		}
		if want := "v0.1.0"; got != want {
			t.Fatalf("exactTagAt = %q, want %q", got, want)
		}
	})

	t.Run("returns a single tag when HEAD has multiple", func(t *testing.T) {
		repo := initTestRepo(t)
		runGit(t, repo, "tag", "v0.1.0-alias")

		got, err := exactTagAt(repo)
		if err != nil {
			t.Fatalf("exactTagAt returned error: %v", err)
		}
		if got == "" {
			t.Fatal("exactTagAt returned empty string, want one of the HEAD tags")
		}
		if got != "v0.1.0" && got != "v0.1.0-alias" {
			t.Fatalf("exactTagAt = %q, want one of v0.1.0 or v0.1.0-alias", got)
		}
	})
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
