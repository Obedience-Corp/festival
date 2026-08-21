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

fail() {
    echo "tool-versions: $*" >&2
    exit 1
}

require_submodule() {
    local dir="$1"

    [ -d "$repo_root/$dir" ] || fail "submodule directory is missing: $dir"
    git -C "$repo_root/$dir" rev-parse --verify HEAD >/dev/null 2>&1 ||
        fail "submodule is not checked out: $dir (run: git submodule update --init --recursive)"
}

# Exact tag when HEAD is tagged, otherwise the nearest tag plus commit, and a
# bare short hash when the submodule has no tags at all.
tool_version() {
    local dir="$1"

    git -C "$repo_root/$dir" describe --tags --exact-match HEAD 2>/dev/null ||
        git -C "$repo_root/$dir" describe --tags --always
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
    require_submodule "$tool"
done

emit FEST_VERSION "$(tool_version fest)"
emit FEST_COMMIT "$(tool_commit fest)"
emit CAMP_VERSION "$(tool_version camp)"
emit CAMP_COMMIT "$(tool_commit camp)"
