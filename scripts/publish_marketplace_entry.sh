#!/usr/bin/env bash
set -euo pipefail

: "${FESTIVAL_TAG:?missing FESTIVAL_TAG}"
: "${RELEASE_CHANNEL:?missing RELEASE_CHANNEL}"

# Schema-check the generated package manifest before cloning the
# marketplace. Signature is not required: the marketplace Sign metadata
# workflow signs after the PR opens. Schema drift must fail this release,
# not a user's install. Tests inject FESTIVAL_METADATA_BIN; the release
# path uses the festival-installer submodule.
if [ ! -f dist/marketplace/obey-package.json ]; then
  echo "refusing to publish: missing dist/marketplace/obey-package.json" >&2
  exit 1
fi
if [ -n "${FESTIVAL_METADATA_BIN:-}" ]; then
  "${FESTIVAL_METADATA_BIN}" validate --kind manifest dist/marketplace/obey-package.json
else
  go -C festival-installer run ./cmd/festival-metadata validate --kind manifest ../dist/marketplace/obey-package.json
fi

# gh authenticates from GH_TOKEN. Reuse the marketplace publish token so the
# git push and the gh pr create below share one credential.
export GH_TOKEN="${MARKETPLACE_PUBLISH_TOKEN:-${GH_TOKEN:-}}"

repo_url="${MARKETPLACE_REPO_URL:-}"
if [ -z "${repo_url}" ]; then
  : "${MARKETPLACE_PUBLISH_TOKEN:?missing MARKETPLACE_PUBLISH_TOKEN}"
  repo_url="https://x-access-token:${MARKETPLACE_PUBLISH_TOKEN}@github.com/Obedience-Corp/marketplace.git"
fi

work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

git clone --depth 1 "${repo_url}" "${work}/marketplace"

# Verify the marketplace trust root before editing anything. After the edit
# below, the manifest this script just wrote is unsigned by construction, so
# verify would always fail there and the check would be useless. Before the
# edit, verify answers the question that actually matters to a release: was
# the trust root intact when we started. A release must not quietly publish
# on top of a broken trust root.
if ! (cd "${work}/marketplace" && go run ./tools/metadata verify); then
  echo "refusing to publish: ${repo_url##*/} does not verify before this change" >&2
  echo "fix the marketplace signatures first (run the Sign metadata workflow)" >&2
  exit 1
fi

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

branch="release/festival-${FESTIVAL_TAG}-${RELEASE_CHANNEL}"
git switch -c "${branch}"
git push --set-upstream origin "${branch}"

# MARKETPLACE_REPO_URL is the local-fixture injection point. When it is set,
# stop after the branch push so a fixture test can drive the git half with no
# real GitHub involved.
if [ -n "${MARKETPLACE_REPO_URL:-}" ]; then
  echo "MARKETPLACE_REPO_URL set; pushed ${branch} without opening a pull request"
  exit 0
fi

pr_url="$(gh pr create \
  --repo Obedience-Corp/marketplace \
  --base main \
  --head "${branch}" \
  --title "Publish obedience-corp/festival ${FESTIVAL_TAG} (${RELEASE_CHANNEL})" \
  --body "Automated marketplace entry for ${FESTIVAL_TAG} on the ${RELEASE_CHANNEL} channel.

The metadata in this branch is not signed yet. Run the **Sign metadata**
workflow against this branch, or let its pull_request trigger sign it, then
merge. Merging unsigned metadata to main will break strict installs.")"

echo "opened ${pr_url}"
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
  echo "Marketplace entry PR: ${pr_url}" >> "${GITHUB_STEP_SUMMARY}"
fi
