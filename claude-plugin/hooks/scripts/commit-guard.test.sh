#!/usr/bin/env bash
# Unit tests for commit-guard.sh raw-git-commit detection.
#
# Sources the guard (its main() is guarded so sourcing only defines functions)
# and exercises is_raw_git_commit against a matrix of realistic command lines,
# including the compound-command and `git -C <path>` bypasses reported in
# review. Pure string logic: no camp, no campaign, no stdin required, so it runs
# anywhere. Invoked by `just plugin check`.
set -u

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./commit-guard.sh
source "$DIR/commit-guard.sh"

fail=0
check() { # $1 want(block|allow)  $2 command
  local want="$1" cmd="$2" got
  if is_raw_git_commit "$cmd"; then got=block; else got=allow; fi
  if [ "$got" = "$want" ]; then
    if [ -n "${COMMIT_GUARD_TEST_VERBOSE:-}" ]; then
      printf 'ok   %-6s %s\n' "$want" "$cmd"
    fi
  else
    printf 'FAIL want=%s got=%s  %s\n' "$want" "$got" "$cmd"
    fail=1
  fi
}

# Raw commits that must be blocked.
check block 'git commit -m x'
check block 'git commit'
check block 'git   commit --amend --no-edit'
check block 'git -C projects/camp commit -m x'          # unquoted path bypass
check block 'git -C fest commit'                        # path substring bypass
check block 'fest commit -m trace; git commit -m sneaky'  # compound after ;
check block 'camp commit -m ok && git commit -m sneaky'   # compound after &&
check block 'camp p commit -m ok || git commit -m sneaky' # compound after ||
check block 'FOO=bar git commit -m x'                   # leading env assignment

# Wrappers and non-commits that must be allowed.
check allow 'camp commit -m x'
check allow 'camp p commit -m x'
check allow 'fest commit -m x'
check allow 'git add -A && camp commit -m x'
check allow 'git add -A'
check allow 'git status'
check allow 'git log --oneline'
check allow 'ls -la'
check allow 'echo git commit'                           # not a git invocation
check allow 'camp commit -m "mentions git commit inline"'  # git commit in message

if [ "$fail" -ne 0 ]; then
  echo "commit-guard tests FAILED" >&2
  exit 1
fi
echo "commit-guard tests passed"
