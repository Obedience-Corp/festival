#!/usr/bin/env bash
# Publish the npm wrapper for an existing Festival GitHub release.

set -euo pipefail

VERSION_SELECTOR="${1:-latest}"
RELEASE_MODE="${2:-stable}"
REPO="${GITHUB_REPOSITORY:-Obedience-Corp/festival}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "$RELEASE_MODE" in
    stable | rc | dev) ;;
    *)
        echo "::error::Unsupported release mode ${RELEASE_MODE}" >&2
        exit 1
        ;;
esac

if ! command -v gh >/dev/null 2>&1; then
    echo "::error::gh is required to resolve and verify Festival GitHub releases" >&2
    exit 1
fi

if ! command -v rsync >/dev/null 2>&1; then
    echo "::error::rsync is required to stage the npm package without mutating the working tree" >&2
    exit 1
fi

if [ "$VERSION_SELECTOR" = "latest" ]; then
    TAG="$(gh release view --repo "$REPO" --json tagName --jq .tagName)"
else
    TAG="${VERSION_SELECTOR#v}"
    TAG="v${TAG}"
    gh release view "$TAG" --repo "$REPO" >/dev/null
fi

VERSION="${TAG#v}"
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    echo "::error::Invalid Festival release tag ${TAG}" >&2
    exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

rsync -a "$ROOT_DIR/npm/" "$TMP_DIR/"

echo "Publishing npm wrapper for Festival ${TAG} from ${REPO}"
echo "Staged package directory: ${TMP_DIR}"

NPM_PACKAGE_DIR="$TMP_DIR" \
NPM_PACKAGE_VERSION="$VERSION" \
RELEASE_MODE="$RELEASE_MODE" \
"$ROOT_DIR/scripts/publish_npm_package.sh"
