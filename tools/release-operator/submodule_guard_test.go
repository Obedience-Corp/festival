package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// newSubmoduleFixture builds a festival repo fixture with real, initialized
// git submodules named fest and camp, each cloned from its own local origin
// repo. Root itself carries an "ancient" prerelease tag (v0.1.2-rc.1),
// mirroring festival's own early tag history: if submodule git commands
// ever fall through to the superproject again, this is the wrong-but-
// plausible tag that resolution would find instead of the submodule's own.
//
// fest/camp submodules are added at their origin's first commit, then each
// origin gains a second commit with the "real" release tags the pin flow
// should resolve to. This mirrors `just refresh-rc`: submodules start
// pinned behind, and pinning should move them forward to the requested
// tags, never to something else.
func newSubmoduleFixture(t *testing.T) (root, campOrigin, festOrigin string) {
	t.Helper()

	// Recent git refuses the local-path transport for submodule clone/update
	// by default (CVE-2022-39253 hardening). Allow it for this test process
	// only: t.Setenv restores the prior value automatically, and the env
	// var is inherited by every git subprocess this test spawns, including
	// the `git submodule update --init` that ensureSubmodulesReady itself
	// runs later against these same local-path origins.
	t.Setenv("GIT_ALLOW_PROTOCOL", "file:https:ssh:git")

	campOrigin = t.TempDir()
	runGit(t, campOrigin, "init", "-b", "main")
	runGit(t, campOrigin, "config", "user.name", "Test User")
	runGit(t, campOrigin, "config", "user.email", "test@example.com")
	writeFile(t, filepath.Join(campOrigin, "README.md"), "camp\n")
	runGit(t, campOrigin, "add", "README.md")
	runGit(t, campOrigin, "commit", "-m", "camp initial")

	festOrigin = t.TempDir()
	runGit(t, festOrigin, "init", "-b", "main")
	runGit(t, festOrigin, "config", "user.name", "Test User")
	runGit(t, festOrigin, "config", "user.email", "test@example.com")
	writeFile(t, filepath.Join(festOrigin, "README.md"), "fest\n")
	runGit(t, festOrigin, "add", "README.md")
	runGit(t, festOrigin, "commit", "-m", "fest initial")

	root = initTestRepo(t)
	// pinFromLatest fetches the festival repo's own "origin" too, so root
	// needs one even though these tests only care about the fest/camp
	// submodule origins.
	addBareOrigin(t, root)
	runGit(t, root, "tag", "v0.1.2-rc.1")

	runGit(t, root, "submodule", "add", campOrigin, "camp")
	runGit(t, root, "submodule", "add", festOrigin, "fest")
	runGit(t, root, "commit", "-m", "add submodules")

	return root, campOrigin, festOrigin
}

// addOriginRelease adds a second commit to an origin repo (as created by
// newSubmoduleFixture) and tags it with every tag in tags, all pointing at
// that same new commit.
func addOriginRelease(t *testing.T, origin string, tags ...string) {
	t.Helper()
	writeFile(t, filepath.Join(origin, "RELEASE.md"), strings.Join(tags, "\n")+"\n")
	runGit(t, origin, "add", "RELEASE.md")
	runGit(t, origin, "commit", "-m", "release "+strings.Join(tags, ","))
	for _, tag := range tags {
		runGit(t, origin, "tag", tag)
	}
}

// deinitSubmodule empties a submodule's working directory so it reproduces
// a worktree whose submodule was never initialized: the directory exists,
// but (unlike a real submodule) has no .git of its own, so plain git
// commands run against it fall through to the superproject.
func deinitSubmodule(t *testing.T, root, name string) {
	t.Helper()
	runGit(t, root, "submodule", "deinit", "-f", "--", name)
}

func TestSubmoduleIsIndependent(t *testing.T) {
	root, _, _ := newSubmoduleFixture(t)
	campPath := filepath.Join(root, "camp")

	if !submoduleIsIndependent(campPath) {
		t.Fatal("expected camp to be independent right after submodule add")
	}

	deinitSubmodule(t, root, "camp")
	if submoduleIsIndependent(campPath) {
		t.Fatal("expected camp to be non-independent after deinit (uninitialized submodule)")
	}

	if submoduleIsIndependent(filepath.Join(root, "does-not-exist")) {
		t.Fatal("expected a nonexistent directory to be reported as non-independent")
	}
}

// TestEnsureSubmodulesReadyResolvesRealTagsAfterInit reproduces the exact
// incident: with camp uninitialized, tag lookups against camp's path
// silently resolve the superproject's own ancient tag instead of erroring.
// ensureSubmodulesReady must fix that by initializing the submodule before
// any tag is resolved.
func TestEnsureSubmodulesReadyResolvesRealTagsAfterInit(t *testing.T) {
	root, campOrigin, _ := newSubmoduleFixture(t)
	addOriginRelease(t, campOrigin, "v9.9.9-rc.1")
	campPath := filepath.Join(root, "camp")

	deinitSubmodule(t, root, "camp")

	// Reproduce the bug: with camp uninitialized, resolving an rc tag
	// against camp's path silently returns root's own ancient rc tag.
	if got := latestTagForMode(campPath, "rc"); got != "v0.1.2-rc.1" {
		t.Fatalf("latestTagForMode(camp, rc) before fix = %q, want the superproject's ancient tag v0.1.2-rc.1 (bug did not reproduce)", got)
	}

	if err := ensureSubmodulesReady(root); err != nil {
		t.Fatalf("ensureSubmodulesReady returned error: %v", err)
	}

	if !submoduleIsIndependent(campPath) {
		t.Fatal("camp is still not independent after ensureSubmodulesReady")
	}
	if got := latestTagForMode(campPath, "rc"); got != "v9.9.9-rc.1" {
		t.Fatalf("latestTagForMode(camp, rc) after fix = %q, want camp's own tag v9.9.9-rc.1", got)
	}
}

func TestEnsureSubmodulesReadyIsNoopWhenAlreadyInitialized(t *testing.T) {
	root, _, _ := newSubmoduleFixture(t)
	campPath := filepath.Join(root, "camp")

	before := gitRevParse(t, campPath, "HEAD")
	if err := ensureSubmodulesReady(root); err != nil {
		t.Fatalf("ensureSubmodulesReady returned error: %v", err)
	}
	after := gitRevParse(t, campPath, "HEAD")
	if before != after {
		t.Fatalf("camp HEAD moved from %s to %s for an already-initialized submodule", before, after)
	}
}

func TestEnsureSubmodulesReadyRefusesWhenAutoInitFails(t *testing.T) {
	root, campOrigin, _ := newSubmoduleFixture(t)
	deinitSubmodule(t, root, "camp")

	// deinit alone leaves camp's fetched objects cached under
	// .git/modules/camp, so `git submodule update --init` could still
	// succeed locally without the origin. Wipe the cache too, then break
	// the recorded origin, so init must actually fail to clone: this is
	// what forces ensureSubmodulesReady to refuse loudly instead of
	// proceeding with a submodule it could not initialize.
	if err := os.RemoveAll(filepath.Join(root, ".git", "modules", "camp")); err != nil {
		t.Fatalf("remove cached submodule metadata: %v", err)
	}
	if err := os.RemoveAll(campOrigin); err != nil {
		t.Fatalf("remove campOrigin: %v", err)
	}

	err := ensureSubmodulesReady(root)
	if err == nil {
		t.Fatal("expected ensureSubmodulesReady to fail when the submodule origin is unreachable")
	}
	if !strings.Contains(err.Error(), "camp") {
		t.Fatalf("error does not name the failing submodule: %v", err)
	}
	if !strings.Contains(err.Error(), "git submodule update --init") {
		t.Fatalf("error is not actionable (missing the manual recovery command): %v", err)
	}
}

// TestPinFromLatestInitializesUninitializedSubmodulesAndResolvesRealTags is
// the end-to-end regression test for the incident: `just refresh-rc`
// (pinFromLatest with mode=rc) run against a worktree whose submodules are
// uninitialized must initialize them, resolve each submodule's own tags,
// and never touch the superproject's branch or HEAD.
func TestPinFromLatestInitializesUninitializedSubmodulesAndResolvesRealTags(t *testing.T) {
	root, campOrigin, festOrigin := newSubmoduleFixture(t)
	addOriginRelease(t, campOrigin, "v9.9.9-rc.1")
	addOriginRelease(t, festOrigin, "v8.8.8-rc.1")

	deinitSubmodule(t, root, "camp")
	deinitSubmodule(t, root, "fest")

	rootHeadBefore := gitRevParse(t, root, "HEAD")

	ctx := testRepoContext(t, root)
	if err := ctx.pinFromLatest("rc", "latest", "latest"); err != nil {
		t.Fatalf("pinFromLatest returned error: %v", err)
	}

	campPath := filepath.Join(root, "camp")
	festPath := filepath.Join(root, "fest")

	campTag, err := exactTagAt(campPath)
	if err != nil {
		t.Fatalf("exactTagAt(camp): %v", err)
	}
	if campTag != "v9.9.9-rc.1" {
		t.Fatalf("camp pinned to %q, want camp's own tag v9.9.9-rc.1", campTag)
	}

	festTag, err := exactTagAt(festPath)
	if err != nil {
		t.Fatalf("exactTagAt(fest): %v", err)
	}
	if festTag != "v8.8.8-rc.1" {
		t.Fatalf("fest pinned to %q, want fest's own tag v8.8.8-rc.1", festTag)
	}

	if branch := gitRevParse(t, root, "--abbrev-ref", "HEAD"); branch != "main" {
		t.Fatalf("festival repo branch = %q, want main (pin must never detach the superproject)", branch)
	}
	if head := gitRevParse(t, root, "HEAD"); head != rootHeadBefore {
		t.Fatalf("festival repo HEAD moved from %s to %s; pin must not commit or move the superproject's own HEAD", rootHeadBefore, head)
	}

	staged, err := gitOutput(root, "diff", "--cached", "--name-only")
	if err != nil {
		t.Fatalf("git diff --cached: %v", err)
	}
	if !strings.Contains(staged, "camp") || !strings.Contains(staged, "fest") {
		t.Fatalf("expected fest and camp pointer updates staged, got: %q", staged)
	}
}

// TestPinFromLatestRollsBackOnPostCheckoutMismatch forces a failure after
// fest has already been pinned successfully: camp's resolved commit carries
// both the requested rc tag and an unrelated, higher-sorting stable tag, so
// verifyCheckedOutTag catches HEAD resolving to the wrong tag. pinFromLatest
// must then restore fest to its starting commit and leave the superproject
// on its starting branch, rather than leaving a half-applied pin behind.
func TestPinFromLatestRollsBackOnPostCheckoutMismatch(t *testing.T) {
	root, campOrigin, festOrigin := newSubmoduleFixture(t)
	festStart := gitRevParse(t, filepath.Join(root, "fest"), "HEAD")
	festStartBranch := gitRevParse(t, filepath.Join(root, "fest"), "--abbrev-ref", "HEAD")
	campStart := gitRevParse(t, filepath.Join(root, "camp"), "HEAD")
	rootHeadBefore := gitRevParse(t, root, "HEAD")

	addOriginRelease(t, festOrigin, "v8.8.8-rc.1")
	// v99.0.0 sorts ahead of v9.9.9-rc.1 under --sort=-v:refname, so
	// exactTagAt (which does not filter by mode) disagrees with the rc
	// resolution that picked v9.9.9-rc.1, exactly the "resolved commit
	// doesn't match the requested tag" case the sanity check exists for.
	addOriginRelease(t, campOrigin, "v9.9.9-rc.1", "v99.0.0")

	ctx := testRepoContext(t, root)
	err := ctx.pinFromLatest("rc", "latest", "latest")
	if err == nil {
		t.Fatal("expected pinFromLatest to fail on the ambiguous camp tag")
	}
	if !strings.Contains(err.Error(), "camp") {
		t.Fatalf("error does not mention camp: %v", err)
	}

	festHead := gitRevParse(t, filepath.Join(root, "fest"), "HEAD")
	if festHead != festStart {
		t.Fatalf("fest HEAD = %s after rollback, want restored starting commit %s", festHead, festStart)
	}
	if branch := gitRevParse(t, filepath.Join(root, "fest"), "--abbrev-ref", "HEAD"); branch != festStartBranch {
		t.Fatalf("fest branch = %q after rollback, want restored starting branch %q", branch, festStartBranch)
	}

	campHead := gitRevParse(t, filepath.Join(root, "camp"), "HEAD")
	if campHead != campStart {
		t.Fatalf("camp HEAD = %s after rollback, want unchanged starting commit %s", campHead, campStart)
	}

	if branch := gitRevParse(t, root, "--abbrev-ref", "HEAD"); branch != "main" {
		t.Fatalf("festival repo branch = %q after rollback, want main", branch)
	}
	if head := gitRevParse(t, root, "HEAD"); head != rootHeadBefore {
		t.Fatalf("festival repo HEAD = %s after rollback, want unchanged %s", head, rootHeadBefore)
	}

	status, statusErr := gitOutput(root, "status", "--porcelain")
	if statusErr != nil {
		t.Fatalf("git status: %v", statusErr)
	}
	if strings.TrimSpace(status) != "" {
		t.Fatalf("festival repo is dirty after rollback: %q", status)
	}
}

func TestGitRefCaptureAndRestore(t *testing.T) {
	repo := initTestRepo(t)

	ref, err := captureGitRef(repo)
	if err != nil {
		t.Fatalf("captureGitRef returned error: %v", err)
	}
	if ref.branch != "main" {
		t.Fatalf("captured branch = %q, want main", ref.branch)
	}

	writeFile(t, filepath.Join(repo, "next.txt"), "next\n")
	runGit(t, repo, "add", "next.txt")
	runGit(t, repo, "commit", "-m", "next commit")
	runGit(t, repo, "checkout", "--detach", "HEAD")

	if err := ref.restore(repo); err != nil {
		t.Fatalf("restore returned error: %v", err)
	}
	if branch := gitRevParse(t, repo, "--abbrev-ref", "HEAD"); branch != "main" {
		t.Fatalf("branch after restore = %q, want main", branch)
	}
	if head := gitRevParse(t, repo, "HEAD"); head != ref.commit {
		t.Fatalf("HEAD after restore = %s, want %s", head, ref.commit)
	}
}

func TestVerifyCheckedOutTag(t *testing.T) {
	repo := initTestRepo(t)

	if err := verifyCheckedOutTag(repo, "test", "v0.1.0"); err != nil {
		t.Fatalf("verifyCheckedOutTag returned error for matching tag: %v", err)
	}

	if err := verifyCheckedOutTag(repo, "test", "v9.9.9"); err == nil {
		t.Fatal("expected verifyCheckedOutTag to fail for a tag HEAD does not carry")
	}
}
