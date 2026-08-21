#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# shellcheck source=scripts/lib/submodules.sh
. "$repo_root/scripts/lib/submodules.sh"

mode=""
require_bundle=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        # Release-only gate. Doc regeneration also runs this script (see
        # .justfiles/docs.just), and refreshing docs is not a release, so the
        # bundle requirement is opt-in rather than on by default. `just test
        # release-pins` passes it, which is the path .github/workflows/release.yaml
        # takes, so a release is impossible until the pins carry the variable.
        --require-bundle) require_bundle=1 ;;
        -*)
            echo "ERROR: unknown flag: $1" >&2
            exit 1
            ;;
        *) mode="$1" ;;
    esac
    shift
done

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

    if ! require_initialized_submodule "$repo_root" "$repo"; then
        failures=$((failures + 1))
        return
    fi

    # --dirty marks uncommitted changes, so a modified checkout cannot pass as
    # the clean tag it is pinned to.
    tag="$(git -C "$repo_root/$repo" describe --tags --exact-match --dirty 2>/dev/null || true)"
    if [[ -z "$tag" ]]; then
        echo "ERROR: $repo is not pinned to an exact tag at HEAD" >&2
        failures=$((failures + 1))
        return
    fi

    if [[ "$tag" == *-dirty ]]; then
        echo "ERROR: $repo has uncommitted changes (${tag}); a release must build the pinned tag exactly" >&2
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

# The bundled binaries carry the festival suite tag in internal/version.Bundle.
# `go build -X` on a symbol that does not exist is silently ignored, so a pin
# without the variable produces binaries that report no bundle at all and give
# the user no way to tell which suite release they came from. Checking the
# source is the only way to catch that before the release is published.
check_bundle_support() {
    local repo="$1"
    local file="$repo_root/$repo/internal/version/version.go"

    if [[ ! -f "$file" ]]; then
        echo "ERROR: $repo has no internal/version/version.go to check for bundle support" >&2
        failures=$((failures + 1))
        return
    fi

    if ! grep -qE '^[[:space:]]*Bundle[[:space:]]*=' "$file"; then
        echo "ERROR: $repo is pinned to a release without internal/version.Bundle, so the bundle version cannot be stamped" >&2
        echo "       remedy: re-pin $repo to a release that carries internal/version.Bundle" >&2
        failures=$((failures + 1))
        return
    fi

    echo "$repo supports the bundle version"
}

check_repo fest
check_repo camp
check_repo festival-installer

if [[ "$require_bundle" -eq 1 ]]; then
    check_bundle_support fest
    check_bundle_support camp
fi

if [[ "$failures" -gt 0 ]]; then
    echo "release pin check failed for ${mode} channel" >&2
    exit 1
fi

echo "release pin check passed for ${mode} channel"
