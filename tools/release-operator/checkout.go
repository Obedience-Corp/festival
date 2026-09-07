package main

import (
	"errors"
	"fmt"
)

// releaseBaseBranch is the branch on origin that every bundled stable
// release ships from. It names a branch on the remote, not a requirement
// about the local checkout.
const releaseBaseBranch = "main"

// originBaseRef is the remote-tracking ref for releaseBaseBranch.
const originBaseRef = "refs/remotes/origin/" + releaseBaseBranch

// checkoutState is where the festival repo's HEAD stands relative to
// origin/main.
//
// The release flow used to require a local branch literally named main.
// That made it unrunnable from a normal festival checkout: the repo is
// worked through git worktrees, and git refuses to check out one branch in
// two worktrees at once, so whichever worktree happened to hold main became
// the only place a release could be cut. What a release actually needs is
// the commit origin/main points at, so the flow checks the commit and lets
// the branch be named anything, or be no branch at all.
type checkoutState struct {
	// Branch is the checked-out branch, or "" when HEAD is detached.
	Branch string
	// Head is the commit HEAD resolves to.
	Head string
	// OriginBase is the commit origin/main resolves to, or "" when that
	// remote-tracking ref has never been fetched into this checkout.
	OriginBase string
	// Dirty reports uncommitted changes in the superproject worktree.
	Dirty bool
}

// atReleaseBase reports whether HEAD is exactly the commit origin/main
// points at.
func (s checkoutState) atReleaseBase() bool {
	return s.Head != "" && s.Head == s.OriginBase
}

// onBaseBranch reports whether the local branch is literally named main,
// regardless of where it stands relative to origin.
func (s checkoutState) onBaseBranch() bool {
	return s.Branch == releaseBaseBranch
}

// String renders the checkout for release output: the branch name when HEAD
// is on one, and where the detached HEAD stands otherwise.
func (s checkoutState) String() string {
	switch {
	case s.Branch != "":
		return s.Branch
	case s.atReleaseBase():
		return "detached at origin/" + releaseBaseBranch
	default:
		return "detached at " + shortCommit(s.Head)
	}
}

func shortCommit(commit string) string {
	if commit == "" {
		return "an unknown commit"
	}
	if len(commit) > 12 {
		return commit[:12]
	}
	return commit
}

// readCheckoutState reads the checkout's position from local refs only. A
// missing origin/main leaves OriginBase empty rather than failing, so the
// dev and rc paths, which never consult it, keep working in a checkout that
// has not fetched it.
func readCheckoutState(root string) (checkoutState, error) {
	branch, err := gitOutput(root, "rev-parse", "--abbrev-ref", "HEAD")
	if err != nil {
		return checkoutState{}, err
	}
	if branch == "HEAD" {
		branch = ""
	}
	head, err := gitOutput(root, "rev-parse", "HEAD")
	if err != nil {
		return checkoutState{}, err
	}
	base, err := gitOutput(root, "rev-parse", "-q", "--verify", originBaseRef)
	if err != nil {
		base = ""
	}
	dirty, err := worktreeDirty(root)
	if err != nil {
		return checkoutState{}, err
	}
	return checkoutState{Branch: branch, Head: head, OriginBase: base, Dirty: dirty}, nil
}

// resolveCheckoutState refreshes origin/main and then reads the position, so
// callers compare against what the remote holds now rather than whatever
// this checkout last saw.
func resolveCheckoutState(root string) (checkoutState, error) {
	if err := fetchReleaseBase(root); err != nil {
		return checkoutState{}, err
	}
	return readCheckoutState(root)
}

// fetchReleaseBase updates refs/remotes/origin/main. The refspec is spelled
// out so the update does not depend on the remote's configured fetch
// refspec, which a purpose-built release checkout can be missing.
func fetchReleaseBase(root string) error {
	return runCmd(root, nil, "git", "fetch", "origin",
		"+refs/heads/"+releaseBaseBranch+":"+originBaseRef)
}

// requireReleaseBase refuses to run a mutating release flow from a checkout
// that is not exactly origin/main with a clean tree. The branch's name does
// not matter; its commit does.
func (r *repoContext) requireReleaseBase(state checkoutState) error {
	if state.Dirty {
		return errors.New("festival repo has uncommitted changes")
	}
	if state.OriginBase == "" {
		return fmt.Errorf("origin/%s is not available in this checkout; run: git fetch origin %s",
			releaseBaseBranch, releaseBaseBranch)
	}
	if state.atReleaseBase() {
		return nil
	}

	relation, err := r.relationToReleaseBase(state)
	if err != nil {
		return err
	}
	return fmt.Errorf(
		"festival checkout %s is %s origin/%s (HEAD %s, origin/%s %s); a release must be cut from origin/%s, so run: git fetch origin %s && git checkout --detach origin/%s",
		state, relation, releaseBaseBranch,
		shortCommit(state.Head), releaseBaseBranch, shortCommit(state.OriginBase),
		releaseBaseBranch, releaseBaseBranch, releaseBaseBranch)
}

// relationToReleaseBase describes how HEAD sits against origin/main for the
// refusal message.
func (r *repoContext) relationToReleaseBase(state checkoutState) (string, error) {
	behind, err := isAncestor(r.Root, state.Head, state.OriginBase)
	if err != nil {
		return "", err
	}
	if behind {
		return "behind", nil
	}
	ahead, err := isAncestor(r.Root, state.OriginBase, state.Head)
	if err != nil {
		return "", err
	}
	if ahead {
		return "ahead of", nil
	}
	return "diverged from", nil
}

// returnToReleaseBase leaves whatever transient branch the release flow
// created and lands the checkout back on the release base at origin/main.
// prefer names the branch the run started on, or "" when it started
// detached. A checkout that cannot hold that branch, which is every worktree
// when another worktree already holds it, lands detached at origin/main
// instead.
func (r *repoContext) returnToReleaseBase(prefer string) error {
	if err := fetchReleaseBase(r.Root); err != nil {
		return err
	}
	if prefer != "" {
		if err := r.runGit("switch", prefer); err == nil {
			return r.runGit("merge", "--ff-only", originBaseRef)
		}
	}
	return r.runGit("checkout", "--detach", originBaseRef)
}
