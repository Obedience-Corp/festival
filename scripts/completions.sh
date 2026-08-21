#!/usr/bin/env bash
# Generate shell completions for the bundled CLIs.
# Called by goreleaser before.hooks.
# CLI list: scripts/completion-clis.txt (one row per CLI).
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

# shellcheck source=completion-assets.sh
source "$root/scripts/completion-assets.sh"

mkdir -p completions

tmp_names=()
cleanup() {
    local name
    for name in "${tmp_names[@]+"${tmp_names[@]}"}"; do
        rm -f "completions/.${name}-tmp"
    done
}
trap cleanup EXIT

echo "Building temporary binaries for completion generation..."
while read -r name src_dir main_pkg; do
    tmp_names+=("$name")
    (cd "$src_dir" && go build -o "../completions/.${name}-tmp" "$main_pkg")
done < <(completion_asset_rows)

echo "Generating completions..."
: > completions/manifest.txt
while read -r name _; do
    ./completions/."${name}"-tmp completion bash > "completions/${name}.bash"
    ./completions/."${name}"-tmp completion zsh > "completions/_${name}"
    ./completions/."${name}"-tmp completion fish > "completions/${name}.fish"
    completion_src_names_for "$name" >> completions/manifest.txt
done < <(completion_asset_rows)

echo "Completions generated in completions/"
