#!/usr/bin/env bash
# Unit tests for ensure-festival.sh local-version parsing.
#
# Sources the installer (its main() is guarded so sourcing only defines
# functions) and exercises parse_local_fest_version / is_release_version
# against the SessionStart nag that treated `go: go1.26.4` as the installed
# festival version. Pure string logic: no network, no temp dirs. Invoked by
# `just plugin check`.
set -u

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./ensure-festival.sh
source "$DIR/ensure-festival.sh"

fail=0
check_parse() { # $1 want  $2 short  $3 full
  local want="$1" short="$2" full="$3" got
  got="$(parse_local_fest_version "$short" "$full")"
  if [ "$got" = "$want" ]; then
    if [ -n "${ENSURE_FESTIVAL_TEST_VERBOSE:-}" ]; then
      printf 'ok   parse %-12s\n' "$want"
    fi
  else
    printf 'FAIL parse want=%s got=%s\n' "$want" "$got"
    fail=1
  fi
}

check_release() { # $1 want(yes|no)  $2 token
  local want="$1" token="$2" got
  if is_release_version "$token"; then got=yes; else got=no; fi
  if [ "$got" = "$want" ]; then
    if [ -n "${ENSURE_FESTIVAL_TEST_VERBOSE:-}" ]; then
      printf 'ok   release %-4s %s\n' "$want" "$token"
    fi
  else
    printf 'FAIL release want=%s got=%s  %s\n' "$want" "$got" "$token"
    fail=1
  fi
}

classic_full=$'fest dev\ncommit: 00bc23e\nbuilt: 2026-08-17T23:38:19Z\ngo: go1.26.4\nplatform: darwin/arm64'
buggy="$(printf '%s\n' "$classic_full" | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1 || true)"
if [ "$buggy" = "1.26.4" ]; then
  if [ -n "${ENSURE_FESTIVAL_TEST_VERBOSE:-}" ]; then
    printf 'ok   fixture still reproduces the greedy grep\n'
  fi
else
  printf 'FAIL fixture no longer reproduces the grep bug (got %s)\n' "$buggy"
  fail=1
fi

# --short is the version token; full output's Go line must not win.
check_parse "dev" "dev" "$classic_full"
check_parse "v0.2.16" "v0.2.16" $'fest v0.2.16\ngo: go1.26.4'
check_parse "v9.8.7" "v9.8.7" $'fest v9.8.7\ngo: go1.26.4'

# Fallback when --short is empty: field 2 of the first line, not a blob grep.
check_parse "dev" "" "$classic_full"
check_parse "v0.2.16" "" $'fest v0.2.16\ncommit: abc\ngo: go1.26.4'
check_parse "" "" ""

# Accidental full-block in the short slot: first field is "fest", never 1.26.4.
check_parse "fest" "$classic_full" "$classic_full"

check_release yes "v0.2.16"
check_release yes "0.2.16"
check_release yes "v9.8.7"
check_release yes "v0.2.16-rc.1"
check_release no "dev"
check_release no ""
check_release no "unknown"
check_release no "fest"
check_release no "go1.26.4"
check_release no "v0.2.16-dev.3"
check_release no "0.2.16-dev"

if [ "$fail" -ne 0 ]; then
  echo "ensure-festival version parse tests failed" >&2
  exit 1
fi

echo "ensure-festival version parse tests passed"
