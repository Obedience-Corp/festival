#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mode="${1:-}"

case "${mode}" in
    stable) pattern='^v[0-9]+(\.[0-9]+)*$' ;;
    rc) pattern='^v[0-9]+(\.[0-9]+)*-rc\.[0-9]+$' ;;
    dev) pattern='^v[0-9]+(\.[0-9]+)*-dev\.[0-9]+$' ;;
    *)
        echo "ERROR: mode must be 'stable', 'rc', or 'dev' (got: ${mode:-<empty>})" >&2
        exit 1
        ;;
esac

failures=0

check_repo() {
    local repo="$1"
    local tag=""

    tag="$(git -C "$repo_root/$repo" describe --tags --exact-match HEAD 2>/dev/null || true)"
    if [[ -z "$tag" ]]; then
        echo "ERROR: $repo is not pinned to an exact tag at HEAD" >&2
        failures=$((failures + 1))
        return
    fi

    if ! printf '%s\n' "$tag" | grep -Eq "$pattern"; then
        echo "ERROR: $repo tag $tag does not match required ${mode} channel" >&2
        failures=$((failures + 1))
        return
    fi

    echo "$repo pinned to $tag"
}

check_repo fest
check_repo camp

if [[ "$failures" -gt 0 ]]; then
    echo "release pin check failed for ${mode} channel" >&2
    exit 1
fi

echo "release pin check passed for ${mode} channel"
