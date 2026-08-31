#!/usr/bin/env bash
# Submit a Go module graph to GitHub's dependency submission API.
#
# actions/go-dependency-submission names the manifest after go-build-target
# (default "all"). For gitlink go.mod files, Dependabot alerts stay attached to
# paths like fest/go.mod, so the snapshot must use that path as the manifest
# name/source_location or stale alerts never auto-resolve.
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <path-to-go.mod>" >&2
  exit 2
fi

go_mod_path="$1"
if [[ "$(basename "$go_mod_path")" != "go.mod" || ! -f "$go_mod_path" ]]; then
  echo "$go_mod_path is not an existing go.mod file" >&2
  exit 1
fi

go_mod_dir="$(dirname "$go_mod_path")"
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required}"
: "${GITHUB_SHA:?GITHUB_SHA is required}"
: "${GITHUB_REF:?GITHUB_REF is required}"
: "${GITHUB_TOKEN:?GITHUB_TOKEN is required}"
: "${GITHUB_RUN_ID:=local}"
: "${GITHUB_WORKFLOW:=submit-go-dependency-snapshot}"
: "${GITHUB_JOB:=submit}"
export GITHUB_REPOSITORY GITHUB_SHA GITHUB_REF GITHUB_TOKEN GITHUB_RUN_ID GITHUB_WORKFLOW GITHUB_JOB

tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT

GOWORK=off go -C "$go_mod_dir" list -m -json all >"$tmp"

snapshot="$(GOWORK=off python3 - "$go_mod_path" "$tmp" <<'PY'
import json, os, sys, datetime
from pathlib import Path

go_mod_path = sys.argv[1]
modules_path = Path(sys.argv[2])

mods = []
buf = []
for line in modules_path.read_text().splitlines(True):
    buf.append(line)
    if line.strip() == "}":
        mods.append(json.loads("".join(buf)))
        buf = []

resolved = {}
for mod in mods:
    path = mod.get("Path")
    version = mod.get("Version")
    if not path or not version:
        continue
    purl = f"pkg:golang/{path}@{version}"
    resolved[purl] = {
        "package_url": purl,
        "relationship": "indirect" if mod.get("Indirect") else "direct",
        "scope": "runtime",
        "dependencies": [],
    }

now = datetime.datetime.now(datetime.timezone.utc).replace(microsecond=0).isoformat().replace("+00:00", "Z")
snapshot = {
    "version": 0,
    "sha": os.environ["GITHUB_SHA"],
    "ref": os.environ["GITHUB_REF"],
    "job": {
        "correlator": f'{os.environ["GITHUB_WORKFLOW"]}-{os.environ["GITHUB_JOB"]}-{go_mod_path}',
        "id": str(os.environ["GITHUB_RUN_ID"]),
    },
    "detector": {
        "name": "festival-submit-go-dependency-snapshot",
        "version": "1.0.0",
        "url": "https://github.com/Obedience-Corp/festival",
    },
    "scanned": now,
    "manifests": {
        go_mod_path: {
            "name": go_mod_path,
            "file": {"source_location": go_mod_path},
            "resolved": resolved,
        }
    },
}
print(json.dumps(snapshot))
PY
)"

owner="${GITHUB_REPOSITORY%/*}"
repo="${GITHUB_REPOSITORY#*/}"

package_count="$(
  SNAPSHOT_JSON="$snapshot" GO_MOD_PATH="$go_mod_path" python3 - <<'PY'
import json, os
snapshot = json.loads(os.environ["SNAPSHOT_JSON"])
print(len(snapshot["manifests"][os.environ["GO_MOD_PATH"]]["resolved"]))
PY
)"
echo "Submitting dependency snapshot for ${go_mod_path} (${package_count} packages)"

response="$(
  curl -fsSL \
    -X POST \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "Accept: application/vnd.github+json" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -H "Content-Type: application/json" \
    --data "$snapshot" \
    "https://api.github.com/repos/${owner}/${repo}/dependency-graph/snapshots"
)"

RESPONSE_JSON="$response" python3 - <<'PY'
import json, os
result = json.loads(os.environ["RESPONSE_JSON"])
print(
    f"result={result.get('result')} "
    f"created_at={result.get('created_at')} "
    f"message={result.get('message')}"
)
PY
