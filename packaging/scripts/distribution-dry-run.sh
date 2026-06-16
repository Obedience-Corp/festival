#!/usr/bin/env bash
# Distribution dry-run: confirm every target's distribution surface is present and the install
# command is ready, WITHOUT performing any live external push. Per packaging/DISTRIBUTION.md (D006):
# Codex ships a self-hosted marketplace.json; Cursor is a manual web submission; opencode and Gemini
# install straight from the git repo. Nothing here pushes anywhere.

set -euo pipefail

repo_root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$repo_root"

fail=0
require() {
    local label="$1"
    shift
    local missing=0
    for p in "$@"; do
        if [ ! -e "$repo_root/$p" ]; then
            echo "  MISSING surface: $p" >&2
            fail=1
            missing=1
        fi
    done
    if [ "$missing" -eq 0 ]; then
        echo "  surface: $* (present)"
    fi
    echo "  $label"
}

echo "Distribution dry-run (no live push)"
echo ""

echo "Codex -> self-hosted marketplace"
require "install: /plugin marketplace add Obedience-Corp/festival && /plugin install festival" \
    .agents/plugins/marketplace.json .codex-plugin/plugin.json

echo ""
echo "Cursor -> Cursor Marketplace (manual web submission)"
require "install: submit repo at cursor.com/marketplace/publish, then /add-plugin" \
    .cursor-plugin/plugin.json

echo ""
echo "opencode -> npm package or git URL in opencode.json plugin array"
require "install: add this repo's git URL (or published package) to opencode.json plugin" \
    .opencode/plugins/festival.js

echo ""
echo "Gemini -> gemini extensions install (GitHub shorthand)"
require "install: gemini extensions install Obedience-Corp/festival" \
    gemini-extension.json GEMINI.md

echo ""
if [ "$fail" -ne 0 ]; then
    echo "distribution dry-run FAILED: a surface is missing (run 'just plugin generate')" >&2
    exit 1
fi
echo "distribution dry-run OK: all surfaces present, no push performed"
