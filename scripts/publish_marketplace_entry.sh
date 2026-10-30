#!/usr/bin/env bash
set -euo pipefail

: "${FESTIVAL_TAG:?missing FESTIVAL_TAG}"
: "${RELEASE_CHANNEL:?missing RELEASE_CHANNEL}"
if [ "$RELEASE_CHANNEL" != stable ]; then
  echo "Marketplace stable promotion does not include $RELEASE_CHANNEL releases"
  exit 0
fi
if [[ ! "$FESTIVAL_TAG" =~ ^v(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)$ ]]; then
  echo "invalid stable suite tag" >&2
  exit 1
fi
manifest=dist/marketplace/obey-package.json
[ -f "$manifest" ] || { echo "missing $manifest" >&2; exit 1; }
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
validator="${FESTIVAL_METADATA_BIN:-$work/festival-metadata}"
if [ -z "${FESTIVAL_METADATA_BIN:-}" ]; then
  go -C festival-installer build -o "$validator" ./cmd/festival-metadata
fi
"$validator" validate --kind manifest "$manifest"

# Publish the release operator's manifest with the actual release, so scheduled
# reconciliation can recover without rebuilding or guessing component versions.
# Never replace metadata already published for this version.
if GH_TOKEN="${FESTIVAL_RELEASE_TOKEN:-${GH_TOKEN:-}}" gh release view "$FESTIVAL_TAG" --repo Obedience-Corp/festival --json assets --jq '.assets[].name' | grep -Fxq obey-package.json; then
  GH_TOKEN="${FESTIVAL_RELEASE_TOKEN:-${GH_TOKEN:-}}" gh release download "$FESTIVAL_TAG" --repo Obedience-Corp/festival --pattern obey-package.json --dir "$work"
  cmp "$manifest" "$work/obey-package.json" || { echo "refusing to replace immutable published suite metadata" >&2; exit 1; }
else
  GH_TOKEN="${FESTIVAL_RELEASE_TOKEN:-${GH_TOKEN:-}}" gh release upload "$FESTIVAL_TAG" "$manifest" --repo Obedience-Corp/festival
fi

# Keep the existing cross-repository publisher credential. Signing stays in the
# marketplace workflow; reconciliation waits for final-SHA checks and readback.
if [ -n "${MARKETPLACE_PUBLISH_TOKEN:-}" ]; then
  export GH_TOKEN="$MARKETPLACE_PUBLISH_TOKEN"
fi
python3 scripts/reconcile_marketplace.py --package festival --version "${FESTIVAL_TAG#v}" --validator "$validator"
