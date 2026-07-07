package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestShipBranchName(t *testing.T) {
	got := shipBranchName("v0.2.12")
	if want := "release-pin/v0.2.12"; got != want {
		t.Fatalf("shipBranchName = %q, want %q", got, want)
	}
	if strings.HasPrefix(got, "release/v") {
		t.Fatalf("ship branch %q collides with the rc release/vX.Y.Z branch convention", got)
	}
}

func TestShipsViaPullRequest(t *testing.T) {
	tests := []struct {
		branch string
		want   bool
	}{
		{branch: "main", want: true},
		{branch: "develop", want: false},
		{branch: "release/v0.3.0", want: false},
		{branch: "release-pin/v0.2.12", want: false},
	}

	for _, tt := range tests {
		t.Run(tt.branch, func(t *testing.T) {
			if got := shipsViaPullRequest(tt.branch); got != tt.want {
				t.Fatalf("shipsViaPullRequest(%q) = %v, want %v", tt.branch, got, tt.want)
			}
		})
	}
}

func TestShipPinnedArtifactsNoDiffIsNoop(t *testing.T) {
	repo := initTestRepo(t)
	addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	before := gitRevParse(t, repo, "HEAD")
	if err := ctx.shipPinnedArtifacts("v0.2.0", "v0.4.8", "v0.2.17", "v0.4.8", "v0.2.17"); err != nil {
		t.Fatalf("shipPinnedArtifacts returned error: %v", err)
	}
	if after := gitRevParse(t, repo, "HEAD"); after != before {
		t.Fatalf("HEAD moved from %s to %s without staged changes", before, after)
	}
}

func TestShipPinnedArtifactsDirectPushOffMain(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	runGit(t, repo, "switch", "-c", "develop")
	stagePinnedDocChange(t, repo, "dev pin\n")

	if err := ctx.shipPinnedArtifacts("v0.2.0-dev.1", "v0.4.8", "v0.2.17", "v0.4.9-dev.1", "v0.2.17"); err != nil {
		t.Fatalf("shipPinnedArtifacts returned error: %v", err)
	}

	if branch := gitRevParse(t, repo, "--abbrev-ref", "HEAD"); branch != "develop" {
		t.Fatalf("current branch = %q, want develop", branch)
	}
	local := gitRevParse(t, repo, "HEAD")
	remote := gitRevParse(t, bare, "develop")
	if local != remote {
		t.Fatalf("origin develop = %s, want pushed commit %s", remote, local)
	}
	message, err := gitOutput(repo, "log", "-1", "--format=%s")
	if err != nil {
		t.Fatalf("read commit message: %v", err)
	}
	if want := "Release: pin fest v0.4.9-dev.1"; message != want {
		t.Fatalf("commit message = %q, want %q", message, want)
	}
}

func TestPrepareMainForBundleFastForwardsStaleMain(t *testing.T) {
	repo := initTestRepo(t)
	addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	writeFile(t, filepath.Join(repo, "next.txt"), "next\n")
	runGit(t, repo, "add", "next.txt")
	runGit(t, repo, "commit", "-m", "next release commit")
	runGit(t, repo, "push", "origin", "main")
	ahead := gitRevParse(t, repo, "HEAD")
	runGit(t, repo, "reset", "--hard", "HEAD~1")

	if err := ctx.prepareMainForBundle(); err != nil {
		t.Fatalf("prepareMainForBundle returned error: %v", err)
	}
	if head := gitRevParse(t, repo, "HEAD"); head != ahead {
		t.Fatalf("HEAD = %s, want origin/main %s", head, ahead)
	}
}

func TestPrepareMainForBundleLeavesOtherBranchesAlone(t *testing.T) {
	repo := initTestRepo(t)
	addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	runGit(t, repo, "switch", "-c", "develop")
	before := gitRevParse(t, repo, "HEAD")

	if err := ctx.prepareMainForBundle(); err != nil {
		t.Fatalf("prepareMainForBundle returned error: %v", err)
	}
	if branch := gitRevParse(t, repo, "--abbrev-ref", "HEAD"); branch != "develop" {
		t.Fatalf("current branch = %q, want develop", branch)
	}
	if head := gitRevParse(t, repo, "HEAD"); head != before {
		t.Fatalf("HEAD moved from %s to %s on a non-main branch", before, head)
	}
}

func TestPrepareMainForBundleRecoversFromStaleShipBranch(t *testing.T) {
	repo := initTestRepo(t)
	addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	runGit(t, repo, "switch", "-C", "release-pin/v0.2.12")
	stagePinnedDocChange(t, repo, "abandoned pin\n")
	runGit(t, repo, "commit", "-m", "Release: pin fest v0.4.9")

	if err := ctx.prepareMainForBundle(); err != nil {
		t.Fatalf("prepareMainForBundle returned error: %v", err)
	}
	if branch := gitRevParse(t, repo, "--abbrev-ref", "HEAD"); branch != "main" {
		t.Fatalf("current branch = %q, want main", branch)
	}
	if _, err := gitOutput(repo, "rev-parse", "--verify", "refs/heads/release-pin/v0.2.12"); err == nil {
		t.Fatal("stale ship branch release-pin/v0.2.12 still exists")
	}
}

func TestPrepareMainForBundleRejectsDirtyMain(t *testing.T) {
	repo := initTestRepo(t)
	addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	writeFile(t, filepath.Join(repo, "README.md"), "dirty\n")

	if err := ctx.prepareMainForBundle(); err == nil {
		t.Fatal("expected prepareMainForBundle to fail on a dirty main worktree")
	}
}

func TestReleasePRBodyMentionsTag(t *testing.T) {
	body := releasePRBody("v0.2.12", "Release: pin fest v0.4.9")
	if !strings.Contains(body, "v0.2.12") {
		t.Fatalf("PR body does not mention the release tag: %q", body)
	}
	if !strings.Contains(body, "Release: pin fest v0.4.9") {
		t.Fatalf("PR body does not include the release message: %q", body)
	}
}

func testRepoContext(t *testing.T, repo string) *repoContext {
	t.Helper()
	ctx, err := newRepoContext(repo)
	if err != nil {
		t.Fatalf("newRepoContext: %v", err)
	}
	return ctx
}

func addBareOrigin(t *testing.T, repo string) string {
	t.Helper()
	bare := t.TempDir()
	runGit(t, bare, "init", "--bare", "-b", "main")
	runGit(t, repo, "remote", "add", "origin", bare)
	runGit(t, repo, "push", "-u", "origin", "main")
	return bare
}

func stagePinnedDocChange(t *testing.T, repo, content string) {
	t.Helper()
	dir := filepath.Join(repo, "docs", "cli-reference")
	if err := os.MkdirAll(dir, 0o755); err != nil {
		t.Fatalf("mkdir %s: %v", dir, err)
	}
	writeFile(t, filepath.Join(dir, "pin.md"), content)
	runGit(t, repo, "add", "docs/cli-reference")
}

func gitRevParse(t *testing.T, dir string, args ...string) string {
	t.Helper()
	out, err := gitOutput(dir, append([]string{"rev-parse"}, args...)...)
	if err != nil {
		t.Fatalf("git rev-parse %v: %v", args, err)
	}
	return out
}
