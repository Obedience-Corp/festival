#!/usr/bin/env bash
# Generate shell completions for the bundled CLIs.
# Called by goreleaser before.hooks.
set -euo pipefail

mkdir -p completions

cleanup() {
    rm -f completions/.fest-tmp completions/.camp-tmp completions/.festival-tmp
}
trap cleanup EXIT

echo "Building temporary binaries for completion generation..."
(cd fest && go build -o ../completions/.fest-tmp ./cmd/fest)
(cd camp && go build -o ../completions/.camp-tmp ./cmd/camp)
(cd festival-installer && go build -o ../completions/.festival-tmp ./cmd/festival)

echo "Generating completions..."
./completions/.fest-tmp completion bash > completions/fest.bash
./completions/.fest-tmp completion zsh  > completions/_fest
./completions/.fest-tmp completion fish > completions/fest.fish

./completions/.camp-tmp completion bash > completions/camp.bash
./completions/.camp-tmp completion zsh  > completions/_camp
./completions/.camp-tmp completion fish > completions/camp.fish

./completions/.festival-tmp completion bash > completions/festival.bash
./completions/.festival-tmp completion zsh  > completions/_festival
./completions/.festival-tmp completion fish > completions/festival.fish

echo "Completions generated in completions/"
