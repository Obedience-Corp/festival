#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d "${TMPDIR:-/tmp}/festival-cli-docs-profile.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

stable_root="$tmp_dir/stable"
dev_root="$tmp_dir/dev"

cd "$repo_root"

CLI_PROFILE=stable CLI_DOCS_ROOT="$stable_root" just docs fest >/dev/null

if [ -e "$stable_root/fest/fest_explore.md" ]; then
    echo "stable docs unexpectedly included fest_explore.md"
    exit 1
fi

if grep -q '^\* \[fest explore\]' "$stable_root/fest/fest.md"; then
    echo "stable docs unexpectedly referenced fest explore"
    exit 1
fi

CLI_PROFILE=dev CLI_DOCS_ROOT="$dev_root" just docs fest >/dev/null

if [ ! -e "$dev_root/fest/fest_explore.md" ]; then
    echo "dev docs did not generate fest_explore.md"
    exit 1
fi

if ! grep -q '^\* \[fest explore\]' "$dev_root/fest/fest.md"; then
    echo "dev docs did not reference fest explore"
    exit 1
fi
