package main

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// newSubmoduleFixture builds a festival repo fixture with real, initialized
// git submodules for every entry in components, each cloned from its own
// local origin repo. Root itself carries an "ancient" prerelease tag
// (v0.1.2-rc.1), mirroring festival's own early tag history: if submodule
// git commands ever fall through to the superproject again, this is the
// wrong-but-plausible tag that resolution would find instead of the
// submodule's own.
//
// Every submodule is added at its origin's first commit, then each origin
// gains a second commit with the "real" release tags the pin flow should
// resolve to. This mirrors `just refresh-rc`: submodules start pinned
// behind, and pinning should move them forward to the requested tags, never
// to something else.
//
// origins is keyed by Component.Dir ("fest", "camp", "festival-installer").
func newSubmoduleFixture(t *testing.T) (root string, origins map[string]string) {
	t.Helper()

	// Recent git refuses the local-path transport for submodule clone/update
	// by default (CVE-2022-39253 hardening). Allow it for this test process
	// only: t.Setenv restores the prior value automatically, and the env
	// var is inherited by every git subprocess this test spawns, including
	// the `git submodule update --init` that ensureSubmodulesReady itself
	// runs later against these same local-path origins.
	t.Setenv("GIT_ALLOW_PROTOCOL", "file:https:ssh:git")

	origins = make(map[string]string, len(components))
	for _, c := range components {
		origin := t.TempDir()
		runGit(t, origin, "init", "-b", "main")
		runGit(t, origin, "config", "user.name", "Test User")
		runGit(t, origin, "config", "user.email", "test@example.com")
		writeFile(t, filepath.Join(origin, "README.md"), c.Dir+"\n")
		runGit(t, origin, "add", "README.md")
		runGit(t, origin, "commit", "-m", c.Dir+" initial")
		origins[c.Dir] = origin
	}

	root = initTestRepo(t)
	// pinFromLatest fetches the festival repo's own "origin" too, so root
	// needs one even though these tests only care about the component
	// submodule origins.
	addBareOrigin(t, root)
	runGit(t, root, "tag", "v0.1.2-rc.1")

	for _, c := range components {
		runGit(t, root, "submodule", "add", origins[c.Dir], c.Dir)
	}
	runGit(t, root, "commit", "-m", "add submodules")

	return root, origins
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

// allSelectors returns a tag selector map with value for every component,
// keyed by Component.Dir. Most pinFromLatest tests want the same selector
// (usually "latest") for every component.
func allSelectors(value string) map[string]string {
	m := make(map[string]string, len(components))
	for _, c := range components {
		m[c.Dir] = value
	}
	return m
}

func TestSubmoduleIsIndependent(t *testing.T) {
	root, _ := newSubmoduleFixture(t)
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
	root, origins := newSubmoduleFixture(t)
	addOriginRelease(t, origins["camp"], "v9.9.9-rc.1")
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
	root, _ := newSubmoduleFixture(t)
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
	root, origins := newSubmoduleFixture(t)
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
	if err := os.RemoveAll(origins["camp"]); err != nil {
		t.Fatalf("remove camp origin: %v", err)
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
	root, origins := newSubmoduleFixture(t)
	addOriginRelease(t, origins["camp"], "v9.9.9-rc.1")
	addOriginRelease(t, origins["fest"], "v8.8.8-rc.1")
	addOriginRelease(t, origins["festival-installer"], "v7.7.7-rc.1")

	for _, c := range components {
		deinitSubmodule(t, root, c.Dir)
	}

	rootHeadBefore := gitRevParse(t, root, "HEAD")

	ctx := testRepoContext(t, root)
	if err := ctx.pinFromLatest("rc", allSelectors("latest")); err != nil {
		t.Fatalf("pinFromLatest returned error: %v", err)
	}

	wantTag := map[string]string{"camp": "v9.9.9-rc.1", "fest": "v8.8.8-rc.1", "festival-installer": "v7.7.7-rc.1"}
	for _, c := range components {
		got, err := exactTagAt(filepath.Join(root, c.Dir))
		if err != nil {
			t.Fatalf("exactTagAt(%s): %v", c.Dir, err)
		}
		if got != wantTag[c.Dir] {
			t.Fatalf("%s pinned to %q, want its own tag %q", c.Dir, got, wantTag[c.Dir])
		}
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
	stagedLines := strings.Split(strings.TrimSpace(staged), "\n")
	for _, c := range components {
		found := false
		for _, line := range stagedLines {
			if line == c.Dir {
				found = true
				break
			}
		}
		if !found {
			t.Fatalf("expected %s pointer update staged, got: %q", c.Dir, staged)
		}
	}
}

// TestPinFromLatestSucceedsWhenPinnedCommitCarriesMultipleTags pins the bug
// fix in place: a release commit is routinely tagged both vX.Y.Z-rc.N and,
// later, vX.Y.Z. verifyCheckedOutTag must not treat the extra, higher-
// sorting stable tag as a mismatch when the requested rc tag is present.
func TestPinFromLatestSucceedsWhenPinnedCommitCarriesMultipleTags(t *testing.T) {
	root, origins := newSubmoduleFixture(t)
	addOriginRelease(t, origins["fest"], "v8.8.8-rc.1")
	// v99.0.0 sorts ahead of v9.9.9-rc.1 under --sort=-v:refname; exactTagAt
	// alone would have picked v99.0.0, which is exactly the false-positive
	// verifyCheckedOutTag must no longer produce.
	addOriginRelease(t, origins["camp"], "v9.9.9-rc.1", "v99.0.0")
	addOriginRelease(t, origins["festival-installer"], "v7.7.7-rc.1")

	ctx := testRepoContext(t, root)
	if err := ctx.pinFromLatest("rc", allSelectors("latest")); err != nil {
		t.Fatalf("pinFromLatest returned error for a multi-tagged pinned commit: %v", err)
	}

	campTag, err := exactTagAtForMode(filepath.Join(root, "camp"), "rc")
	if err != nil {
		t.Fatalf("exactTagAtForMode(camp, rc): %v", err)
	}
	if campTag != "v9.9.9-rc.1" {
		t.Fatalf("camp pinned to %q, want v9.9.9-rc.1", campTag)
	}
}

// captureAllRefs snapshots HEAD and branch for every component submodule,
// keyed by Component.Dir, for later rollback assertions.
func captureAllRefs(t *testing.T, root string) (heads, branches map[string]string) {
	t.Helper()
	heads = make(map[string]string, len(components))
	branches = make(map[string]string, len(components))
	for _, c := range components {
		path := filepath.Join(root, c.Dir)
		heads[c.Dir] = gitRevParse(t, path, "HEAD")
		branches[c.Dir] = gitRevParse(t, path, "--abbrev-ref", "HEAD")
	}
	return heads, branches
}

// assertAllRefsRestored asserts every component submodule is back at the
// HEAD/branch captureAllRefs recorded, and that the festival repo itself is
// on main at rootHeadBefore with a clean worktree.
func assertAllRefsRestored(t *testing.T, root string, heads, branches map[string]string, rootHeadBefore string) {
	t.Helper()
	for _, c := range components {
		path := filepath.Join(root, c.Dir)
		if head := gitRevParse(t, path, "HEAD"); head != heads[c.Dir] {
			t.Fatalf("%s HEAD = %s after rollback, want restored starting commit %s", c.Dir, head, heads[c.Dir])
		}
		if branch := gitRevParse(t, path, "--abbrev-ref", "HEAD"); branch != branches[c.Dir] {
			t.Fatalf("%s branch = %q after rollback, want restored starting branch %q", c.Dir, branch, branches[c.Dir])
		}
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

// TestPinFromLatestRollsBackWhenCampCheckoutFailsAfterFestSucceeds forces a
// real, mid-flow failure after fest has already been resolved, checked out,
// and verified successfully: camp's own index is locked, so its checkout
// fails outright, before festival-installer (later in component order) is
// ever reached. pinFromLatest must then restore fest, camp, and
// festival-installer to their starting commit/branch and leave the
// superproject on its starting branch, rather than leaving a half-applied
// pin behind.
func TestPinFromLatestRollsBackWhenCampCheckoutFailsAfterFestSucceeds(t *testing.T) {
	root, origins := newSubmoduleFixture(t)
	startHeads, startBranches := captureAllRefs(t, root)
	rootHeadBefore := gitRevParse(t, root, "HEAD")

	addOriginRelease(t, origins["fest"], "v8.8.8-rc.1")
	addOriginRelease(t, origins["camp"], "v9.9.9-rc.1")
	addOriginRelease(t, origins["festival-installer"], "v7.7.7-rc.1")

	// Lock camp's own index (its real git dir lives under
	// root/.git/modules/camp, independent of fest's and root's own index),
	// so `git checkout` inside camp fails after fest's own resolve/
	// checkout/verify has already completed successfully.
	campIndexLock := filepath.Join(root, ".git", "modules", "camp", "index.lock")
	writeFile(t, campIndexLock, "")

	ctx := testRepoContext(t, root)
	err := ctx.pinFromLatest("rc", allSelectors("latest"))
	if err == nil {
		t.Fatal("expected pinFromLatest to fail while camp's index is locked")
	}

	if rmErr := os.Remove(campIndexLock); rmErr != nil && !os.IsNotExist(rmErr) {
		t.Fatalf("remove camp index.lock: %v", rmErr)
	}

	assertAllRefsRestored(t, root, startHeads, startBranches, rootHeadBefore)
}

// TestPinFromLatestRollsBackWhenHubCheckoutFailsAfterFestAndCampSucceed is
// the new interesting case a third component adds: fest and camp both
// succeed (resolved, checked out, verified), then festival-installer's own
// checkout fails. pinFromLatest must restore all three components, not only
// the ones that had already succeeded.
func TestPinFromLatestRollsBackWhenHubCheckoutFailsAfterFestAndCampSucceed(t *testing.T) {
	root, origins := newSubmoduleFixture(t)
	startHeads, startBranches := captureAllRefs(t, root)
	rootHeadBefore := gitRevParse(t, root, "HEAD")

	addOriginRelease(t, origins["fest"], "v8.8.8-rc.1")
	addOriginRelease(t, origins["camp"], "v9.9.9-rc.1")
	addOriginRelease(t, origins["festival-installer"], "v7.7.7-rc.1")

	hubIndexLock := filepath.Join(root, ".git", "modules", "festival-installer", "index.lock")
	writeFile(t, hubIndexLock, "")

	ctx := testRepoContext(t, root)
	err := ctx.pinFromLatest("rc", allSelectors("latest"))
	if err == nil {
		t.Fatal("expected pinFromLatest to fail while festival-installer's index is locked")
	}

	if rmErr := os.Remove(hubIndexLock); rmErr != nil && !os.IsNotExist(rmErr) {
		t.Fatalf("remove festival-installer index.lock: %v", rmErr)
	}

	assertAllRefsRestored(t, root, startHeads, startBranches, rootHeadBefore)
}

// TestPinFromLatestRollsBackRegardlessOfWhichComponentFails is a
// table-driven generalization of the two tests above: whichever component's
// checkout fails, every component and the festival repo itself must be
// restored to its starting ref. A fourth entry in components is covered by
// this test automatically, with no new test code required.
func TestPinFromLatestRollsBackRegardlessOfWhichComponentFails(t *testing.T) {
	for _, failing := range components {
		t.Run(failing.Dir, func(t *testing.T) {
			root, origins := newSubmoduleFixture(t)
			startHeads, startBranches := captureAllRefs(t, root)
			rootHeadBefore := gitRevParse(t, root, "HEAD")

			for _, c := range components {
				addOriginRelease(t, origins[c.Dir], "v9.9.9-rc.1")
			}

			lock := filepath.Join(root, ".git", "modules", failing.Dir, "index.lock")
			writeFile(t, lock, "")

			ctx := testRepoContext(t, root)
			if err := ctx.pinFromLatest("rc", allSelectors("latest")); err == nil {
				t.Fatalf("expected pinFromLatest to fail while %s's index is locked", failing.Dir)
			}
			if rmErr := os.Remove(lock); rmErr != nil && !os.IsNotExist(rmErr) {
				t.Fatalf("remove %s index.lock: %v", failing.Dir, rmErr)
			}

			assertAllRefsRestored(t, root, startHeads, startBranches, rootHeadBefore)
		})
	}
}

// TestPinFromLatestRejectsDirtyRootBeforeInitializingSubmodules pins the
// clean-tree-check ordering: a dirty superproject must be rejected before
// ensureSubmodulesReady runs, since auto-initializing a submodule is itself
// a mutation and a command that is about to refuse for a dirty tree should
// not perform that mutation first.
func TestPinFromLatestRejectsDirtyRootBeforeInitializingSubmodules(t *testing.T) {
	root, _ := newSubmoduleFixture(t)
	deinitSubmodule(t, root, "camp")

	writeFile(t, filepath.Join(root, "README.md"), "dirty\n")

	ctx := testRepoContext(t, root)
	if err := ctx.pinFromLatest("rc", allSelectors("latest")); err == nil {
		t.Fatal("expected pinFromLatest to fail on a dirty festival repo")
	}

	if submoduleIsIndependent(filepath.Join(root, "camp")) {
		t.Fatal("camp was initialized even though the run should have refused on a dirty root first")
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

	// A release commit is routinely tagged both vX.Y.Z-rc.N and, later,
	// vX.Y.Z. The requested (lower-sorting) tag being present must still
	// pass, even though a higher-sorting tag also points at the same
	// commit: exactTagAt alone would have picked v99.0.0 here and wrongly
	// reported a mismatch.
	runGit(t, repo, "tag", "v99.0.0")
	if err := verifyCheckedOutTag(repo, "test", "v0.1.0"); err != nil {
		t.Fatalf("verifyCheckedOutTag returned error for a requested tag present on a multi-tagged HEAD: %v", err)
	}

	// A genuinely different commit must still fail.
	writeFile(t, filepath.Join(repo, "next.txt"), "next\n")
	runGit(t, repo, "add", "next.txt")
	runGit(t, repo, "commit", "-m", "next commit")
	runGit(t, repo, "tag", "v0.2.0")
	if err := verifyCheckedOutTag(repo, "test", "v0.1.0"); err == nil {
		t.Fatal("expected verifyCheckedOutTag to fail when HEAD moved to a genuinely different commit")
	}
}
