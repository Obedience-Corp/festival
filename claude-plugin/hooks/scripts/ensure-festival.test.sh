#!/usr/bin/env bash
# Unit tests for ensure-festival.sh local-version parsing.
#
# Sources the installer (its main() is guarded so sourcing only defines
# functions) and exercises parse_local_fest_version / is_release_version
# against the SessionStart nag that treated `go: go1.26.4` as the installed
# festival version, plus parse_bundle_version / has_build_profile, which decide
# which of `fest version`'s three shapes carries a suite version to compare.
# Pure string logic: no network, no temp dirs. Invoked by `just plugin check`.
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

check_bundle() { # $1 want  $2 full
  local want="$1" full="$2" got
  got="$(parse_bundle_version "$full")"
  if [ "$got" = "$want" ]; then
    if [ -n "${ENSURE_FESTIVAL_TEST_VERBOSE:-}" ]; then
      printf 'ok   bundle  %-10s\n' "${want:-<none>}"
    fi
  else
    printf 'FAIL bundle want=%s got=%s\n' "$want" "$got"
    fail=1
  fi
}

check_profile() { # $1 want(yes|no)  $2 full
  local want="$1" full="$2" got
  if has_build_profile "$full"; then got=yes; else got=no; fi
  if [ "$got" = "$want" ]; then
    if [ -n "${ENSURE_FESTIVAL_TEST_VERBOSE:-}" ]; then
      printf 'ok   profile %-4s\n' "$want"
    fi
  else
    printf 'FAIL profile want=%s got=%s\n' "$want" "$got"
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

# The three shapes of `fest version` the update check has to tell apart. The
# suite build carries a bundle: line; a go install / just build carries only
# profile:; a bundle published before either line existed carries neither.
suite_full=$'fest v0.6.3\nbundle: festival v0.2.18\ncommit: 1a2b3c4\nbuilt: 2026-08-21T00:00:00Z\ngo: go1.26.4\nplatform: darwin/arm64\nprofile: stable'
profile_only_full=$'fest v0.6.3\ncommit: 1a2b3c4\nbuilt: 2026-08-21T00:00:00Z\ngo: go1.26.4\nplatform: darwin/arm64\nprofile: stable'
legacy_full=$'fest v0.2.17\ncommit: 98b9950e\nbuilt: 2026-08-10T00:00:00Z\ngo: go1.26.4\nplatform: darwin/arm64'
suite_crlf="$(printf '%s\n' "$suite_full" | awk '{ printf "%s\r\n", $0 }')"

# The bundle line is the suite version; fest's own v0.6.3 is not, and neither is
# the Go line. A CRLF ending must not ride along into the comparison.
check_bundle "v0.2.18" "$suite_full"
check_bundle "v0.2.18" "$suite_crlf"

# No bundle line: nothing to compare, whichever other lines are present.
check_bundle "" "$profile_only_full"
check_bundle "" "$legacy_full"
check_bundle "" "$classic_full"
check_bundle "" ""

# profile: marks a bundle-capable fest, which is what separates "built outside a
# suite release, stay quiet" from "old bundle, fest's own version is the suite
# version".
check_profile yes "$suite_full"
check_profile yes "$profile_only_full"
check_profile no "$legacy_full"
check_profile no "$classic_full"
check_profile no ""

# The legacy shape still falls through to the existing parser, which reads the
# suite version out of fest's own version field.
check_parse "v0.2.17" "" "$legacy_full"
check_parse "v0.2.17" "v0.2.17" "$legacy_full"
check_release yes "$(parse_local_fest_version "" "$legacy_full")"

# Whatever the shape, no read may ever return the Go toolchain version.
for shape in "$suite_full" "$profile_only_full" "$legacy_full" "$classic_full"; do
  for got in "$(parse_bundle_version "$shape")" "$(parse_local_fest_version "" "$shape")"; do
    case "$got" in
      *1.26.4*)
        printf 'FAIL go toolchain version leaked into a version read: %s\n' "$got"
        fail=1
        ;;
    esac
  done
done

if [ "$fail" -ne 0 ]; then
  echo "ensure-festival version parse tests failed" >&2
  exit 1
fi

echo "ensure-festival version parse tests passed"
