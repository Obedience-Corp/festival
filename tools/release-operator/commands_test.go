package main

import (
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestJustReleaseCommandIsPositional(t *testing.T) {
	got := justReleaseCommand("stable", map[string]string{
		"fest":               "keep",
		"camp":               "keep",
		"festival-installer": "keep",
	})
	want := "just release stable keep keep keep"
	if got != want {
		t.Fatalf("justReleaseCommand = %q, want %q", got, want)
	}
	if strings.Contains(got, "=") {
		t.Fatalf("justReleaseCommand = %q, named just args are positional", got)
	}
	if strings.Contains(got, "festival-installer") {
		t.Fatalf("justReleaseCommand = %q, just param is festival_installer and values are positional", got)
	}
}

func TestSelectorArgsStringFollowsComponentOrder(t *testing.T) {
	got := selectorArgsString(map[string]string{
		"fest":               "latest",
		"camp":               "keep",
		"festival-installer": "v0.1.0",
	})
	if want := "latest keep v0.1.0"; got != want {
		t.Fatalf("selectorArgsString = %q, want %q", got, want)
	}
}

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

// tagMap builds a component-keyed tag map for fest and camp, the two
// components these tests care about; festival-installer is intentionally
// absent, since a missing key on both sides of a current/selected pair
// compares equal (unchanged), matching that component's real starting
// state before it had a submodule pin at all.
func tagMap(fest, camp string) map[string]string {
	return map[string]string{"fest": fest, "camp": camp}
}

func TestShipPinnedArtifactsNoDiffIsNoop(t *testing.T) {
	repo := initTestRepo(t)
	addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	before := gitRevParse(t, repo, "HEAD")
	if err := ctx.shipPinnedArtifacts("v0.2.0", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.8", "v0.2.17")); err != nil {
		t.Fatalf("shipPinnedArtifacts returned error: %v", err)
	}
	if after := gitRevParse(t, repo, "HEAD"); after != before {
		t.Fatalf("HEAD moved from %s to %s without staged changes", before, after)
	}
}

// fakeGH is an in-memory ghClient. mergePullRequest simulates GitHub's
// squash-merge by fast-forwarding the bare origin's main to the pushed ship
// branch tip and deleting the branch, so the operator's post-merge ff-only
// pull of main behaves as it would after a real merge.
type fakeGH struct {
	t           *testing.T
	bare        string
	authed      bool
	canMerge    bool
	canMergeErr error
	openNumber  string
	openErr     error
	createErr   error
	mergeErr    error
	created     int
	merged      int
}

func (f *fakeGH) authenticated() bool { return f.authed }

func (f *fakeGH) viewerCanMerge(string) (bool, error) {
	return f.canMerge, f.canMergeErr
}

func (f *fakeGH) openPullRequestNumber(_, _ string) (string, error) {
	return f.openNumber, f.openErr
}

func (f *fakeGH) createPullRequest(_, _, _, _, _ string) error {
	if f.createErr != nil {
		return f.createErr
	}
	f.created++
	return nil
}

func (f *fakeGH) mergePullRequest(_, branch string) error {
	if f.mergeErr != nil {
		return f.mergeErr
	}
	f.merged++
	tip := gitRevParse(f.t, f.bare, "refs/heads/"+branch)
	runGit(f.t, f.bare, "update-ref", "refs/heads/main", tip)
	runGit(f.t, f.bare, "update-ref", "-d", "refs/heads/"+branch)
	return nil
}

func TestShipPinnedArtifactsShipsViaPullRequestOnMain(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)
	gh := &fakeGH{t: t, bare: bare, authed: true, canMerge: true}
	ctx.gh = gh

	stagePinnedDocChange(t, repo, "stable pin\n")

	if err := ctx.shipPinnedArtifacts("v0.2.12", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.9", "v0.2.17")); err != nil {
		t.Fatalf("shipPinnedArtifacts returned error: %v", err)
	}

	if gh.created != 1 {
		t.Fatalf("createPullRequest called %d times, want 1", gh.created)
	}
	if gh.merged != 1 {
		t.Fatalf("mergePullRequest called %d times, want 1", gh.merged)
	}
	if branch := gitRevParse(t, repo, "--abbrev-ref", "HEAD"); branch != "main" {
		t.Fatalf("current branch = %q, want main", branch)
	}
	if local, remote := gitRevParse(t, repo, "HEAD"), gitRevParse(t, bare, "main"); local != remote {
		t.Fatalf("local main = %s, origin main = %s; want fast-forwarded to merged commit", local, remote)
	}
	if _, err := gitOutput(repo, "rev-parse", "--verify", "refs/heads/release-pin/v0.2.12"); err == nil {
		t.Fatal("local ship branch release-pin/v0.2.12 was not deleted")
	}
}

func TestShipViaPullRequestSkipsCreateWhenPROpen(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)
	gh := &fakeGH{t: t, bare: bare, authed: true, canMerge: true, openNumber: "77"}
	ctx.gh = gh

	stagePinnedDocChange(t, repo, "resumed pin\n")

	if err := ctx.shipPinnedArtifacts("v0.2.12", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.9", "v0.2.17")); err != nil {
		t.Fatalf("shipPinnedArtifacts returned error: %v", err)
	}
	if gh.created != 0 {
		t.Fatalf("createPullRequest called %d times, want 0 when a PR is already open", gh.created)
	}
	if gh.merged != 1 {
		t.Fatalf("mergePullRequest called %d times, want 1", gh.merged)
	}
}

func TestShipViaPullRequestPropagatesOpenPRQueryError(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)
	gh := &fakeGH{t: t, bare: bare, authed: true, canMerge: true, openErr: errors.New("gh: network unreachable")}
	ctx.gh = gh

	stagePinnedDocChange(t, repo, "pin\n")

	err := ctx.shipPinnedArtifacts("v0.2.12", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.9", "v0.2.17"))
	if err == nil {
		t.Fatal("expected a transient open-PR query error to propagate, got nil")
	}
	if gh.created != 0 {
		t.Fatalf("createPullRequest called %d times; a query failure must not fall through to create", gh.created)
	}
	if gh.merged != 0 {
		t.Fatalf("mergePullRequest called %d times, want 0", gh.merged)
	}
}

func TestShipViaPullRequestFailsFastWhenCannotMerge(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)
	gh := &fakeGH{t: t, bare: bare, authed: true, canMerge: false}
	ctx.gh = gh

	stagePinnedDocChange(t, repo, "pin\n")

	err := ctx.shipPinnedArtifacts("v0.2.12", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.9", "v0.2.17"))
	if err == nil {
		t.Fatal("expected an error when the account cannot merge")
	}
	if branch := gitRevParse(t, repo, "--abbrev-ref", "HEAD"); branch != "main" {
		t.Fatalf("current branch = %q; permission check must run before any branch switch", branch)
	}
	if gh.created != 0 || gh.merged != 0 {
		t.Fatalf("create=%d merge=%d; nothing should be attempted when merge is impossible", gh.created, gh.merged)
	}
}

func TestShipViaPullRequestFailsWhenUnauthenticated(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)
	ctx.gh = &fakeGH{t: t, bare: bare, authed: false, canMerge: true}

	stagePinnedDocChange(t, repo, "pin\n")

	if err := ctx.shipPinnedArtifacts("v0.2.12", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.9", "v0.2.17")); err == nil {
		t.Fatal("expected an error when gh is not authenticated")
	}
}

func TestShipPinnedArtifactsDirectPushOffMain(t *testing.T) {
	repo := initTestRepo(t)
	bare := addBareOrigin(t, repo)
	ctx := testRepoContext(t, repo)

	runGit(t, repo, "switch", "-c", "develop")
	stagePinnedDocChange(t, repo, "dev pin\n")

	if err := ctx.shipPinnedArtifacts("v0.2.0-dev.1", tagMap("v0.4.8", "v0.2.17"), tagMap("v0.4.9-dev.1", "v0.2.17")); err != nil {
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
