#!/usr/bin/env bash
set -euo pipefail

: "${FESTIVAL_TAG:?missing FESTIVAL_TAG}"
: "${RELEASE_CHANNEL:?missing RELEASE_CHANNEL}"

repo_url="${MARKETPLACE_REPO_URL:-}"
if [ -z "${repo_url}" ]; then
  : "${MARKETPLACE_PUBLISH_TOKEN:?missing MARKETPLACE_PUBLISH_TOKEN}"
  repo_url="https://x-access-token:${MARKETPLACE_PUBLISH_TOKEN}@github.com/Obedience-Corp/marketplace.git"
fi

work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

git clone --depth 1 "${repo_url}" "${work}/marketplace"

dest_dir="${work}/marketplace/packages/obedience-corp/festival"
mkdir -p "${dest_dir}"
cp dist/marketplace/obey-package.json "${dest_dir}/obey-package.json"

python3 scripts/upsert_marketplace_index.py \
  "${work}/marketplace/index.json" \
  "obedience-corp/festival" \
  "${RELEASE_CHANNEL}"

cd "${work}/marketplace"
git config user.name "obey-release-bot"
git config user.email "release@obediencecorp.com"
git add packages/obedience-corp/festival/obey-package.json index.json

if git diff --cached --quiet; then
  echo "marketplace already up to date for ${FESTIVAL_TAG} (${RELEASE_CHANNEL}); nothing to publish"
  exit 0
fi

git commit -m "Publish obedience-corp/festival ${FESTIVAL_TAG} (${RELEASE_CHANNEL})"
git push origin HEAD:main
