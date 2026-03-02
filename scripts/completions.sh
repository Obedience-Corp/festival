#!/usr/bin/env bash
# Generate shell completions for fest.
# Called by goreleaser before.hooks.
set -euo pipefail

mkdir -p completions

# Build a temporary fest binary for the host platform
echo "Building temporary fest binary for completion generation..."
(cd fest && go build -o ../completions/.fest-tmp ./cmd/fest)

echo "Generating completions..."
./completions/.fest-tmp completion bash > completions/fest.bash
./completions/.fest-tmp completion zsh  > completions/_fest
./completions/.fest-tmp completion fish > completions/fest.fish

rm -f completions/.fest-tmp
echo "Completions generated in completions/"
