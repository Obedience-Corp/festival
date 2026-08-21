package main

import (
	"bytes"
	"encoding/json"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"testing"
	"time"
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
	if got, want := opts.Selectors["fest"], "keep"; got != want {
		t.Fatalf("fest selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["camp"], "latest"; got != want {
		t.Fatalf("camp selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["festival-installer"], "latest"; got != want {
		t.Fatalf("festival-installer selector = %q, want %q", got, want)
	}
}

func TestParseBundleArgsNormalizesKeyValueSelectors(t *testing.T) {
	opts, err := parseBundleArgs([]string{"--fest-tag", "fest=latest", "--camp-tag", "camp=keep", "--festival-installer-tag", "festival-installer=v0.1.0", "stable"})
	if err != nil {
		t.Fatalf("parseBundleArgs returned error: %v", err)
	}

	if got, want := opts.Channel, "stable"; got != want {
		t.Fatalf("channel = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["fest"], "latest"; got != want {
		t.Fatalf("fest selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["camp"], "keep"; got != want {
		t.Fatalf("camp selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["festival-installer"], "v0.1.0"; got != want {
		t.Fatalf("festival-installer selector = %q, want %q", got, want)
	}
}

func TestParsePlanArgsAcceptsSelectors(t *testing.T) {
	opts, err := parsePlanArgs([]string{"--mode", "stable", "--fest-tag", "v0.2.4", "--camp-tag", "keep", "--festival-installer-tag", "keep"})
	if err != nil {
		t.Fatalf("parsePlanArgs returned error: %v", err)
	}

	if got, want := opts.Channel, "stable"; got != want {
		t.Fatalf("channel = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["fest"], "v0.2.4"; got != want {
		t.Fatalf("fest selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["camp"], "keep"; got != want {
		t.Fatalf("camp selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["festival-installer"], "keep"; got != want {
		t.Fatalf("festival-installer selector = %q, want %q", got, want)
	}
}

func TestParsePlanArgsNormalizesKeyValueInputs(t *testing.T) {
	opts, err := parsePlanArgs([]string{"--mode", "mode=stable", "--fest-tag", "fest=latest", "--camp-tag", "camp=keep"})
	if err != nil {
		t.Fatalf("parsePlanArgs returned error: %v", err)
	}

	if got, want := opts.Channel, "stable"; got != want {
		t.Fatalf("channel = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["fest"], "latest"; got != want {
		t.Fatalf("fest selector = %q, want %q", got, want)
	}
	if got, want := opts.Selectors["camp"], "keep"; got != want {
		t.Fatalf("camp selector = %q, want %q", got, want)
	}
}

func TestPrintHelpUsesPositionalJustArgs(t *testing.T) {
	var buf bytes.Buffer
	printHelp(&buf)
	got := buf.String()
	if !strings.Contains(got, "just release stable <fest> <camp> <festival_installer>") {
		t.Fatalf("printHelp missing positional stable recipe:\n%s", got)
	}
	if !strings.Contains(got, "just release plan <mode> <fest> <camp> <festival_installer>") {
		t.Fatalf("printHelp missing positional plan recipe:\n%s", got)
	}
	if !strings.Contains(got, "just release stable keep keep keep") {
		t.Fatalf("printHelp missing copy-paste example:\n%s", got)
	}
	for _, named := range []string{"fest=", "camp=", "mode=", "festival-installer="} {
		if strings.Contains(got, named) {
			t.Fatalf("printHelp still has named just arg %q:\n%s", named, got)
		}
	}
}

func TestNormalizeOptionalAssignment(t *testing.T) {
	tests := []struct {
		name  string
		value string
		key   string
		want  string
	}{
		{
			name:  "strips matching key prefix",
			value: "fest=latest",
			key:   "fest",
			want:  "latest",
		},
		{
			name:  "preserves plain value",
			value: "keep",
			key:   "camp",
			want:  "keep",
		},
		{
			name:  "ignores non-matching prefix",
			value: "camp=keep",
			key:   "fest",
			want:  "camp=keep",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := normalizeOptionalAssignment(tt.value, tt.key); got != tt.want {
				t.Fatalf("normalizeOptionalAssignment(%q, %q) = %q, want %q", tt.value, tt.key, got, tt.want)
			}
		})
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
		runGit(t, repo, "tag", "v0.2.1")
		runGit(t, repo, "tag", "v0.2.2-dev.1")

		if got, err := resolveSelectedTag(repo, "stable", "latest"); err != nil {
			t.Fatalf("resolveSelectedTag(latest) error = %v", err)
		} else if want := "v0.2.1"; got != want {
			t.Fatalf("resolveSelectedTag(latest) = %q, want %q", got, want)
		}

		if got, err := resolveSelectedTag(repo, "stable", "keep"); err != nil {
			t.Fatalf("resolveSelectedTag(keep) error = %v", err)
		} else if want := "v0.2.1"; got != want {
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
		runGit(t, repo, "tag", "v0.1.1")

		got, err := exactTagAt(repo)
		if err != nil {
			t.Fatalf("exactTagAt returned error: %v", err)
		}
		if want := "v0.1.1"; got != want {
			t.Fatalf("exactTagAt = %q, want newest exact tag %q", got, want)
		}
	})

	t.Run("returns newest exact tag for requested mode", func(t *testing.T) {
		repo := initTestRepo(t)
		runGit(t, repo, "tag", "v0.2.7")
		runGit(t, repo, "tag", "v0.2.8")
		runGit(t, repo, "tag", "v0.3.0-dev.1")
		runGit(t, repo, "tag", "v0.3.0-rc.1")

		tests := []struct {
			mode string
			want string
		}{
			{mode: "stable", want: "v0.2.8"},
			{mode: "dev", want: "v0.3.0-dev.1"},
			{mode: "rc", want: "v0.3.0-rc.1"},
		}

		for _, tt := range tests {
			t.Run(tt.mode, func(t *testing.T) {
				got, err := exactTagAtForMode(repo, tt.mode)
				if err != nil {
					t.Fatalf("exactTagAtForMode returned error: %v", err)
				}
				if got != tt.want {
					t.Fatalf("exactTagAtForMode(%q) = %q, want %q", tt.mode, got, tt.want)
				}
			})
		}
	})
}

// TestRunEmitMarketplaceEntry_PublishedAt exercises runEmitMarketplaceEntry,
// the exact function the emit-marketplace-entry command's --published-at
// flag drives, the way release.yaml calls it (real repo-root tag resolution,
// real checksums file, a real timestamp), rather than a hand-built manifest.
// This is the known defect found 2026-08-21: v0.2.17 published with
// published_at="" because the workflow never passed --published-at.
func TestRunEmitMarketplaceEntry_PublishedAt(t *testing.T) {
	repoRoot := t.TempDir()
	tags := map[string]string{"fest": "v0.6.2", "camp": "v0.5.0", "festival-installer": "v0.1.0"}
	for _, c := range components {
		dir := filepath.Join(repoRoot, c.Dir)
		if err := os.MkdirAll(dir, 0o755); err != nil {
			t.Fatalf("mkdir %s: %v", dir, err)
		}
		runGit(t, dir, "init", "-b", "main")
		runGit(t, dir, "config", "user.name", "Test User")
		runGit(t, dir, "config", "user.email", "test@example.com")
		writeFile(t, filepath.Join(dir, "README.md"), c.Dir+"\n")
		runGit(t, dir, "add", "README.md")
		runGit(t, dir, "commit", "-m", "initial commit")
		runGit(t, dir, "tag", tags[c.Dir])
	}

	checksumsPath := filepath.Join(repoRoot, "checksums.txt")
	writeFile(t, checksumsPath, strings.Join([]string{
		"1111111111111111111111111111111111111111111111111111111111111111  festival-9.9.9-macOS-all.tar.gz",
		"2222222222222222222222222222222222222222222222222222222222222222  festival-9.9.9-linux-x86_64.tar.gz",
		"3333333333333333333333333333333333333333333333333333333333333333  festival-9.9.9-linux-arm64.tar.gz",
		"",
	}, "\n"))

	t.Run("a real published-at value reaches the emitted manifest and satisfies the hub schema's date-time format", func(t *testing.T) {
		outputPath := filepath.Join(t.TempDir(), "obey-package.json")
		if err := runEmitMarketplaceEntry(repoRoot, "v9.9.9", "stable", checksumsPath, outputPath, "2026-08-20T01:51:38Z"); err != nil {
			t.Fatalf("runEmitMarketplaceEntry: %v", err)
		}
		raw, err := os.ReadFile(outputPath)
		if err != nil {
			t.Fatalf("read emitted manifest: %v", err)
		}
		var doc struct {
			Releases []struct {
				PublishedAt string `json:"published_at"`
			} `json:"releases"`
		}
		if err := json.Unmarshal(raw, &doc); err != nil {
			t.Fatalf("decode emitted manifest: %v", err)
		}
		if len(doc.Releases) != 1 {
			t.Fatalf("got %d releases, want 1", len(doc.Releases))
		}
		// This is the exact constraint the hub's manifest.schema.json places
		// on published_at ("format": "date-time"), and the exact field that
		// shipped empty in v0.2.17. time.RFC3339 is Go's date-time format.
		if _, err := time.Parse(time.RFC3339, doc.Releases[0].PublishedAt); err != nil {
			t.Fatalf("emitted published_at %q does not satisfy the hub schema's date-time format: %v", doc.Releases[0].PublishedAt, err)
		}
	})

	t.Run("an empty published-at is refused before a manifest is ever written", func(t *testing.T) {
		outputPath := filepath.Join(t.TempDir(), "obey-package.json")
		err := runEmitMarketplaceEntry(repoRoot, "v9.9.9", "stable", checksumsPath, outputPath, "")
		if err == nil {
			t.Fatal("expected an error for empty --published-at, got nil")
		}
		if !strings.Contains(err.Error(), "published_at") {
			t.Fatalf("error %q does not name published_at", err.Error())
		}
		if _, statErr := os.Stat(outputPath); statErr == nil {
			t.Fatal("a manifest was written despite the refusal")
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
