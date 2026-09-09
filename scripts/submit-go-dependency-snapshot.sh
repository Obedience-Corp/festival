#!/usr/bin/env bash
# Submit the Go modules a component actually builds to GitHub's dependency
# submission API.
#
# The manifest is named after the gitlink go.mod path (fest/go.mod, camp/go.mod)
# because Dependabot alerts stay attached to that path; a snapshot under any
# other name never resolves them.
#
# Modules come from `go list -deps -test ./...`, not `go list -m all`. The module
# graph carries requirements that contribute no package to any build (for example
# google.golang.org/grpc pulled in by containerd/errdefs/pkg), and reporting those
# raises Dependabot alerts for code that is never compiled. Modules reached only
# through tests (including SNAPSHOT_TEST_TAGS builds, default "integration") are
# submitted with development scope.
#
# Set SNAPSHOT_DRY_RUN=1 to print the snapshot instead of submitting it.
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
dry_run="${SNAPSHOT_DRY_RUN:-0}"
test_tags="${SNAPSHOT_TEST_TAGS:-integration}"

if [[ "$dry_run" == "1" ]]; then
  : "${GITHUB_REPOSITORY:=Obedience-Corp/festival}"
  : "${GITHUB_SHA:=$(git rev-parse HEAD 2>/dev/null || echo 0000000000000000000000000000000000000000)}"
  : "${GITHUB_REF:=refs/heads/dry-run}"
  : "${GITHUB_TOKEN:=dry-run}"
fi
: "${GITHUB_REPOSITORY:?GITHUB_REPOSITORY is required}"
: "${GITHUB_SHA:?GITHUB_SHA is required}"
: "${GITHUB_REF:?GITHUB_REF is required}"
: "${GITHUB_TOKEN:?GITHUB_TOKEN is required}"
: "${GITHUB_RUN_ID:=local}"
: "${GITHUB_WORKFLOW:=submit-go-dependency-snapshot}"
: "${GITHUB_JOB:=submit}"
export GITHUB_REPOSITORY GITHUB_SHA GITHUB_REF GITHUB_TOKEN GITHUB_RUN_ID GITHUB_WORKFLOW GITHUB_JOB

runtime_modules="$(mktemp)"
all_modules="$(mktemp)"
trap 'rm -f "$runtime_modules" "$all_modules"' EXIT

module_format='{{with .Module}}{{if not .Main}}{{.Path}} {{.Version}} {{.Indirect}}{{with .Replace}} {{.Path}} {{.Version}}{{end}}{{println}}{{end}}{{end}}'
GOWORK=off go -C "$go_mod_dir" list -deps -f "$module_format" ./... | sort -u >"$runtime_modules"
GOWORK=off go -C "$go_mod_dir" list -tags "$test_tags" -deps -test -f "$module_format" ./... | sort -u >"$all_modules"

snapshot="$(python3 - "$go_mod_path" "$runtime_modules" "$all_modules" <<'PY'
import json, os, sys, datetime
from pathlib import Path

go_mod_path = sys.argv[1]
runtime_path = Path(sys.argv[2])
all_path = Path(sys.argv[3])


def read_modules(path):
    modules = {}
    for line in path.read_text().splitlines():
        fields = line.split()
        if len(fields) < 3:
            continue
        module_path, version, indirect = fields[0], fields[1], fields[2] == "true"
        if len(fields) >= 5:
            module_path, version = fields[3], fields[4]
        if not version:
            continue
        modules[f"pkg:golang/{module_path}@{version}"] = indirect
    return modules


runtime = read_modules(runtime_path)
everything = read_modules(all_path)

resolved = {}
for purl, indirect in everything.items():
    resolved[purl] = {
        "package_url": purl,
        "relationship": "indirect" if indirect else "direct",
        "scope": "runtime" if purl in runtime else "development",
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
        "version": "2.0.0",
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

summary="$(
  SNAPSHOT_JSON="$snapshot" GO_MOD_PATH="$go_mod_path" python3 - <<'PY'
import json, os
snapshot = json.loads(os.environ["SNAPSHOT_JSON"])
resolved = snapshot["manifests"][os.environ["GO_MOD_PATH"]]["resolved"].values()
runtime = sum(1 for entry in resolved if entry["scope"] == "runtime")
print(f"{len(resolved)} modules: {runtime} runtime, {len(resolved) - runtime} development")
PY
)"

if [[ "$dry_run" == "1" ]]; then
  echo "Dry run: dependency snapshot for ${go_mod_path} (${summary})" >&2
  printf '%s\n' "$snapshot"
  exit 0
fi

echo "Submitting dependency snapshot for ${go_mod_path} (${summary})"

owner="${GITHUB_REPOSITORY%/*}"
repo="${GITHUB_REPOSITORY#*/}"

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
