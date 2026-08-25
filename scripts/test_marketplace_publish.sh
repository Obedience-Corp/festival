#!/usr/bin/env bash
set -euo pipefail

# Fixture-driven coverage for scripts/publish_marketplace_entry.sh, the
# release step that broke production three releases running. This test
# drives the real script through its existing MARKETPLACE_REPO_URL
# injection point (publish_marketplace_entry.sh:7-11) against a local,
# disposable marketplace repository. No network and no GitHub credentials
# are used.
#
# What this test does NOT cover:
#   - The real `gh pr create` call. The fixture path exits before it
#     (MARKETPLACE_REPO_URL is set, so the script prints "pushed ... without
#     opening a pull request" and stops).
#   - The real marketplace verifier. testdata/marketplace-fixture/tools/metadata
#     is a stand-in that exits 0 or 1 based on FIXTURE_VERIFY_EXIT; it does not
#     check signatures. The real verifier is exercised in sequence 03.
#   - The GitHub Actions wiring in .github/workflows/release.yaml. Only a real
#     release exercises that; both call sites are diffed side by side instead
#     (see results/ for sequence 02, task 01).
#
# Schema coverage: the generated obey-package.json is checked with the real
# festival-metadata validate command. Case "schema invalid" deliberately
# leaves FESTIVAL_METADATA_BIN unset so it exercises the exact module-aware
# fallback used by release CI. The remaining cases inject the built binary.

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "${work}"' EXIT

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "ok: $*"; }

# staged_repo is the cwd the script runs from. publish_marketplace_entry.sh
# reads dist/marketplace/obey-package.json and scripts/upsert_marketplace_index.py
# relative to its cwd (publish_marketplace_entry.sh:20-25), so this staged
# copy stands in for a release checkout instead of writing into this repo's
# real dist/ directory, which would make the suite untrustworthy.
staged_repo="${work}/staged-repo"
mkdir -p "${staged_repo}/scripts" "${staged_repo}/dist/marketplace"
cp "${repo_root}/scripts/publish_marketplace_entry.sh" "${staged_repo}/scripts/publish_marketplace_entry.sh"
cp "${repo_root}/scripts/upsert_marketplace_index.py" "${staged_repo}/scripts/upsert_marketplace_index.py"
chmod +x "${staged_repo}/scripts/publish_marketplace_entry.sh"
cp -R "${repo_root}/festival-installer" "${staged_repo}/festival-installer"

new_release_manifest() {
  # The v9.9.9 entry this test publishes. Distinct from the fixture's seeded
  # v0.2.16 entry (testdata/marketplace-fixture/packages/.../obey-package.json)
  # so a real publish produces a real diff.
  cat <<'JSON'
{
  "aliases": ["festival", "camp", "fest"],
  "class": "product",
  "description": "Fixture entry for the festival suite, published by the test.",
  "display_name": "Festival Suite",
  "homepage": "https://fest.build",
  "host_runtimes": [
    {"display_name": "Camp CLI plugins", "features": [], "runtime": "camp-cli"},
    {"display_name": "Fest CLI plugins", "features": [], "runtime": "fest-cli"}
  ],
  "id": "obedience-corp/festival",
  "licenses": ["Apache-2.0"],
  "provides_binaries": ["camp", "fest"],
  "releases": [
    {
      "artifacts": [
        {"arch": "all", "binaries": ["camp", "fest"], "filename": "festival-9.9.9-macOS-all.tar.gz", "kind": "suite-archive", "os": "darwin", "sha256": "1111111111111111111111111111111111111111111111111111111111111111", "url": "https://example.invalid/festival-9.9.9-macOS-all.tar.gz"}
      ],
      "channel": "stable",
      "compatibility": {"arch": ["amd64", "arm64"], "os": ["darwin", "linux"]},
      "components": {"camp": "0.5.0", "fest": "0.6.2"},
      "dependencies": [],
      "install": {
        "entries": [
          {"executable_name": "camp", "kind": "binary", "source": "camp"},
          {"executable_name": "fest", "kind": "binary", "source": "fest"}
        ]
      },
      "published_at": "2026-08-21T00:00:00Z",
      "version": "9.9.9"
    }
  ],
  "schema_version": 1,
  "summary": "Fixture entry, not the real marketplace.",
  "supported_scopes": ["user"],
  "tags": ["festival", "planning", "cli"]
}
JSON
}
new_release_manifest > "${staged_repo}/dist/marketplace/obey-package.json"

# Build the real hub CLI once. publish_marketplace_entry.sh schema-checks
# through FESTIVAL_METADATA_BIN so this fixture does not need a full
# festival-installer checkout inside staged_repo.
meta_bin="${work}/festival-metadata"
if [ ! -d "${repo_root}/festival-installer/cmd/festival-metadata" ]; then
  fail "festival-installer submodule is required to build festival-metadata"
fi
( cd "${repo_root}/festival-installer" && go build -o "${meta_bin}" ./cmd/festival-metadata ) \
  || fail "go build festival-metadata"
export FESTIVAL_METADATA_BIN="${meta_bin}"

# make_fixture builds a bare "remote" marketplace repository at $1. In
# "stale" mode (the default) it seeds an older entry, so publishing the new
# v9.9.9 entry produces a real diff. In "matching" mode it seeds the exact
# v9.9.9 entry already applied, so a re-publish has nothing to do.
#
# The seeded entry is signed with an ed25519 key generated for this run only
# (openssl, no real key involved), matching the shape of a real signed
# marketplace tree. The stand-in tools/metadata verifier does not check this
# signature; it only reports FIXTURE_VERIFY_EXIT. The signature is here for
# structural realism, not enforcement.
make_fixture() {
  local dest="$1" mode="${2:-stale}"
  local src
  src="$(mktemp -d)"
  mkdir -p "${src}/packages/obedience-corp/festival" "${src}/tools/metadata" "${src}/keys"

  cp "${repo_root}/testdata/marketplace-fixture/go.mod" "${src}/go.mod"
  cp "${repo_root}/testdata/marketplace-fixture/tools/metadata/main.go" "${src}/tools/metadata/main.go"
  cp "${repo_root}/testdata/marketplace-fixture/obey-marketplace.json" "${src}/obey-marketplace.json"

  if [ "${mode}" = "matching" ]; then
    new_release_manifest > "${src}/packages/obedience-corp/festival/obey-package.json"
    cat > "${src}/index.json" <<'JSON'
{
  "source": "official-obey",
  "updatedAt": "2026-08-01T00:00:00Z",
  "packages": [
    {"id": "obedience-corp/festival", "channels": ["stable"]}
  ]
}
JSON
  else
    cp "${repo_root}/testdata/marketplace-fixture/packages/obedience-corp/festival/obey-package.json" \
      "${src}/packages/obedience-corp/festival/obey-package.json"
    cp "${repo_root}/testdata/marketplace-fixture/index.json" "${src}/index.json"
  fi

  if command -v openssl >/dev/null 2>&1; then
    openssl genpkey -algorithm ed25519 -out "${src}/fixture-key.pem" >/dev/null 2>&1
    openssl pkeyutl -sign -inkey "${src}/fixture-key.pem" -rawin \
      -in "${src}/packages/obedience-corp/festival/obey-package.json" \
      -out "${src}/packages/obedience-corp/festival/obey-package.json.sig.bin" >/dev/null 2>&1
    base64 <"${src}/packages/obedience-corp/festival/obey-package.json.sig.bin" \
      >"${src}/packages/obedience-corp/festival/obey-package.json.sig"
    rm -f "${src}/fixture-key.pem" "${src}/packages/obedience-corp/festival/obey-package.json.sig.bin"
  fi

  git -C "${src}" init -q -b main
  git -C "${src}" -c user.email=fixture@example.invalid -c user.name=fixture add -A
  git -C "${src}" -c user.email=fixture@example.invalid -c user.name=fixture \
    commit -q -m "seed fixture marketplace (${mode})"
  git clone -q --bare "${src}" "${dest}"
  rm -rf "${src}"
}

run_script() {
  (cd "${staged_repo}" && env -u MARKETPLACE_PUBLISH_TOKEN \
    bash "${repo_root}/scripts/publish_marketplace_entry.sh")
}

run_script_with_module_validator() {
  (cd "${staged_repo}" && env -u MARKETPLACE_PUBLISH_TOKEN -u FESTIVAL_METADATA_BIN \
    bash "${repo_root}/scripts/publish_marketplace_entry.sh")
}

# --- Case 0: ERROR, generated entry fails hub schema ---------------------
# Empty published_at is the v0.2.17 defect: release-operator used to emit it
# and the failure only showed up at install time.
python3 - "${staged_repo}/dist/marketplace/obey-package.json" <<'PY'
import json, pathlib, sys
p = pathlib.Path(sys.argv[1])
doc = json.loads(p.read_text())
doc["releases"][0]["published_at"] = ""
p.write_text(json.dumps(doc, indent=2) + "\n")
PY
make_fixture "${work}/bare-schema-bad.git"
out="$(FIXTURE_VERIFY_EXIT=0 MARKETPLACE_REPO_URL="${work}/bare-schema-bad.git" \
  FESTIVAL_TAG=v9.9.9 RELEASE_CHANNEL=stable run_script_with_module_validator 2>&1 || true)"
grep -q "published_at" <<<"${out}" || fail "missing published_at schema error: ${out}"
[ -z "$(git --git-dir="${work}/bare-schema-bad.git" branch --list 'release/*')" ] \
  || fail "a branch was pushed despite the schema refusal"
pass "refuses to publish a schema-invalid package manifest, and pushes nothing"
new_release_manifest > "${staged_repo}/dist/marketplace/obey-package.json"

# --- Case 1: ERROR, marketplace does not verify before the change ---------
make_fixture "${work}/bare-broken.git"
out="$(FIXTURE_VERIFY_EXIT=1 MARKETPLACE_REPO_URL="${work}/bare-broken.git" \
  FESTIVAL_TAG=v9.9.9 RELEASE_CHANNEL=stable run_script 2>&1 || true)"
grep -q "does not verify before this change" <<<"${out}" \
  || fail "missing refusal message: ${out}"
[ -z "$(git --git-dir="${work}/bare-broken.git" branch --list 'release/*')" ] \
  || fail "a branch was pushed despite the refusal"
pass "refuses to publish onto an unverifiable marketplace, and pushes nothing"

# --- Case 2: missing FESTIVAL_TAG ------------------------------------------
make_fixture "${work}/bare-missing-tag.git"
out="$(FIXTURE_VERIFY_EXIT=0 MARKETPLACE_REPO_URL="${work}/bare-missing-tag.git" \
  RELEASE_CHANNEL=stable run_script 2>&1 || true)"
grep -q "FESTIVAL_TAG" <<<"${out}" || fail "missing-FESTIVAL_TAG message does not name FESTIVAL_TAG: ${out}"
pass "refuses to run without FESTIVAL_TAG"

# --- Case 3: missing RELEASE_CHANNEL ---------------------------------------
out="$(FIXTURE_VERIFY_EXIT=0 MARKETPLACE_REPO_URL="${work}/bare-missing-tag.git" \
  FESTIVAL_TAG=v9.9.9 run_script 2>&1 || true)"
grep -q "RELEASE_CHANNEL" <<<"${out}" || fail "missing-RELEASE_CHANNEL message does not name RELEASE_CHANNEL: ${out}"
pass "refuses to run without RELEASE_CHANNEL"

# --- Case 4: nothing to publish --------------------------------------------
# The fixture's main already carries exactly the v9.9.9 entry this run would
# publish (simulating a retried or duplicate release). The script must
# detect the empty diff and exit 0 without creating a branch.
make_fixture "${work}/bare-matching.git" matching
out="$(FIXTURE_VERIFY_EXIT=0 MARKETPLACE_REPO_URL="${work}/bare-matching.git" \
  FESTIVAL_TAG=v9.9.9 RELEASE_CHANNEL=stable run_script 2>&1)"
grep -q "already up to date" <<<"${out}" || fail "missing idempotent message: ${out}"
[ -z "$(git --git-dir="${work}/bare-matching.git" branch --list 'release/*')" ] \
  || fail "a branch was pushed for a no-op publish"
pass "re-publishing identical content is a no-op, and pushes no branch"

# --- Case 5: happy path -----------------------------------------------------
make_fixture "${work}/bare-happy.git"
seed_main_before="$(git --git-dir="${work}/bare-happy.git" rev-parse main)"
FIXTURE_VERIFY_EXIT=0 MARKETPLACE_REPO_URL="${work}/bare-happy.git" \
  FESTIVAL_TAG=v9.9.9 RELEASE_CHANNEL=stable run_script >/dev/null
branch_ref="$(git --git-dir="${work}/bare-happy.git" branch --list 'release/festival-v9.9.9-stable')"
[ -n "${branch_ref}" ] || fail "release/festival-v9.9.9-stable was not pushed"
pass "opens (pushes) a release branch for a real change"

# --- Case 6: main untouched --------------------------------------------------
seed_main_after="$(git --git-dir="${work}/bare-happy.git" rev-parse main)"
[ "${seed_main_before}" = "${seed_main_after}" ] \
  || fail "main moved: was ${seed_main_before}, now ${seed_main_after}"
pass "main is untouched by a successful publish; this is what sequence 02 exists for"

echo "all cases passed"
