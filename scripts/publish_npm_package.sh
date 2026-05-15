#!/usr/bin/env bash
# Publish the npm wrapper package for an existing Festival release.

set -euo pipefail

PACKAGE_DIR="${NPM_PACKAGE_DIR:-npm}"
PACKAGE_NAME="${NPM_PACKAGE_NAME:-@obedience-corp/festival}"
RELEASE_MODE="${RELEASE_MODE:-stable}"

if [ -n "${NPM_PACKAGE_VERSION:-}" ]; then
    VERSION="$NPM_PACKAGE_VERSION"
elif [ -n "${GITHUB_REF_NAME:-}" ]; then
    VERSION="${GITHUB_REF_NAME#v}"
else
    echo "::error::NPM_PACKAGE_VERSION or GITHUB_REF_NAME is required" >&2
    exit 1
fi

case "$RELEASE_MODE" in
    stable) NPM_DIST_TAG="${NPM_DIST_TAG:-latest}" ;;
    rc) NPM_DIST_TAG="${NPM_DIST_TAG:-rc}" ;;
    dev) NPM_DIST_TAG="${NPM_DIST_TAG:-dev}" ;;
    *)
        echo "::error::Unsupported release mode ${RELEASE_MODE}" >&2
        exit 1
        ;;
esac

if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
    echo "::error::Invalid npm package version: ${VERSION}" >&2
    exit 1
fi

if [ ! -d "$PACKAGE_DIR" ]; then
    echo "::error::npm package directory not found: ${PACKAGE_DIR}" >&2
    exit 1
fi

echo "Node: $(node --version)"
echo "npm: $(npm --version)"
echo "Package: ${PACKAGE_NAME}@${VERSION}"
echo "Dist tag: ${NPM_DIST_TAG}"
echo "Package directory: ${PACKAGE_DIR}"

can_publish_interactively() {
    [ "${NPM_PUBLISH_INTERACTIVE:-auto}" != "never" ] &&
        [ "${CI:-}" != "true" ] &&
        [ -r /dev/tty ] &&
        [ -w /dev/tty ]
}

if [ "${NPM_SKIP_EXISTING_CHECK:-false}" != "true" ] && npm view "${PACKAGE_NAME}@${VERSION}" version >/dev/null 2>&1; then
    echo "${PACKAGE_NAME}@${VERSION} is already published; leaving registry unchanged."
    exit 0
fi

pushd "$PACKAGE_DIR" >/dev/null
npm version "$VERSION" --no-git-tag-version

set +e
publish_args=(publish --access public --tag "$NPM_DIST_TAG")
if [ "${NPM_PUBLISH_DRY_RUN:-false}" = "true" ]; then
    publish_args+=(--dry-run)
fi

if can_publish_interactively; then
    npm "${publish_args[@]}"
    popd >/dev/null
    exit 0
fi

publish_output="$(npm "${publish_args[@]}" 2>&1)"
publish_status=$?
set -e
printf '%s\n' "$publish_output"

if [ "$publish_status" -ne 0 ]; then
    if printf '%s\n' "$publish_output" | grep -q 'EOTP'; then
        echo "::error::npm publish requires OTP. Re-run from an interactive terminal so npm can prompt for your configured verification method, configure npm trusted publishing for .github/workflows/release.yaml, or replace NPM_TOKEN with a granular token that has bypass 2FA enabled." >&2
    fi
    exit "$publish_status"
fi

popd >/dev/null
