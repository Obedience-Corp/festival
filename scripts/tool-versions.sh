#!/usr/bin/env bash
# Resolve the real version and commit of the camp and fest submodules pinned by
# this repo, and print them as KEY=value lines.
#
# GoReleaser stamps each bundled tool with its own version instead of the
# festival suite tag, so `fest version` reports the fest release the bundle
# actually ships. The output format is GITHUB_ENV-compatible (no `export`), so
# CI can append it straight to "$GITHUB_ENV" and local recipes can load it with
# `set -a; eval "$(bash scripts/tool-versions.sh)"; set +a`.
#
# Emits:
#   FEST_VERSION, FEST_COMMIT, CAMP_VERSION, CAMP_COMMIT

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"

# shellcheck source=scripts/lib/submodules.sh
. "$repo_root/scripts/lib/submodules.sh"

fail() {
    echo "tool-versions: $*" >&2
    exit 1
}

# Exact tag when HEAD is tagged, otherwise the nearest tag plus commit, and a
# bare short hash when the submodule has no tags at all. --dirty appends a
# marker when the checkout has uncommitted changes, so a locally modified
# submodule cannot stamp a clean release tag into a binary. It takes no
# commit-ish argument, hence no explicit HEAD here.
tool_version() {
    local dir="$1"

    git -C "$repo_root/$dir" describe --tags --exact-match --dirty 2>/dev/null ||
        git -C "$repo_root/$dir" describe --tags --always --dirty
}

tool_commit() {
    git -C "$repo_root/$1" rev-parse --short HEAD
}

# Values are eval'd by the just recipes and appended to $GITHUB_ENV in CI, so
# refuse anything that is not a plain tag-or-hash shaped token.
emit() {
    local key="$1"
    local value="$2"

    [ -n "$value" ] || fail "empty value for $key"
    case "$value" in
        *[!A-Za-z0-9._+/-]*) fail "unsafe value for $key: $value" ;;
    esac
    printf '%s=%s\n' "$key" "$value"
}

for tool in fest camp; do
    require_initialized_submodule "$repo_root" "$tool" || exit 1
done

emit FEST_VERSION "$(tool_version fest)"
emit FEST_COMMIT "$(tool_commit fest)"
emit CAMP_VERSION "$(tool_version camp)"
emit CAMP_COMMIT "$(tool_commit camp)"
