#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
projects_root="$(cd "${repo_root}/.." && pwd)"
tmp_dir=""

failures=0

cleanup() {
    if [[ -n "$tmp_dir" && -d "$tmp_dir" ]]; then
        rm -rf "$tmp_dir"
    fi
}
trap cleanup EXIT

if [[ ! -f "$projects_root/camp/README.md" || ! -f "$projects_root/fest/README.md" ]]; then
    echo "skip: doc sync requires campaign workspace layout (../camp and ../fest)" >&2
    exit 0
fi

tmp_dir="$(mktemp -d)"

normalize_readme() {
    local input="$1"
    local output="$2"

    sed \
        -e '/^\[!\[License:/d' \
        -e '/^Functional Source License 1\.1 (FSL-1\.1-ALv2) - See \[LICENSE\](LICENSE) for details\.$/d' \
        -e '/^Business Source License 1\.1 - See \[LICENSE\](LICENSE) for details\.$/d' \
        "$input" > "$output"
}

check_pair() {
    local left="$1"
    local right="$2"
    local label="$3"
    local left_cmp="$left"
    local right_cmp="$right"
    local left_tmp=""
    local right_tmp=""

    if [[ ! -f "$left" ]]; then
        echo "missing source file: $left" >&2
        failures=$((failures + 1))
        return
    fi

    if [[ ! -f "$right" ]]; then
        echo "missing mirror file: $right" >&2
        failures=$((failures + 1))
        return
    fi

    if [[ "$label" == *"README"* ]]; then
        left_tmp="$(mktemp "$tmp_dir/doc-sync-left.XXXXXX")"
        right_tmp="$(mktemp "$tmp_dir/doc-sync-right.XXXXXX")"
        normalize_readme "$left" "$left_tmp"
        normalize_readme "$right" "$right_tmp"
        left_cmp="$left_tmp"
        right_cmp="$right_tmp"
    fi

    if ! diff -u "$left_cmp" "$right_cmp"; then
        echo "doc sync drift: $label" >&2
        failures=$((failures + 1))
    fi

}

check_pair "$projects_root/camp/README.md" "$repo_root/camp/README.md" "camp README"
check_pair "$projects_root/camp/docs/SHORTCUTS.md" "$repo_root/camp/docs/SHORTCUTS.md" "camp SHORTCUTS"
check_pair "$projects_root/camp/docs/shell-integration.md" "$repo_root/camp/docs/shell-integration.md" "camp shell integration"
check_pair "$projects_root/camp/docs/examples/README.md" "$repo_root/camp/docs/examples/README.md" "camp examples README"
check_pair "$projects_root/camp/docs/examples/quick-start.sh" "$repo_root/camp/docs/examples/quick-start.sh" "camp quick-start example"
check_pair "$projects_root/camp/docs/examples/daily-workflows.sh" "$repo_root/camp/docs/examples/daily-workflows.sh" "camp daily workflows example"
check_pair "$projects_root/camp/docs/examples/edge-cases.sh" "$repo_root/camp/docs/examples/edge-cases.sh" "camp edge cases example"
check_pair "$projects_root/camp/internal/scaffold/campaign/templates/AGENTS.md.tmpl" "$repo_root/camp/internal/scaffold/campaign/templates/AGENTS.md.tmpl" "camp AGENTS template"
check_pair "$projects_root/fest/README.md" "$repo_root/fest/README.md" "fest README"
check_pair "$projects_root/fest/methodology/README.md" "$repo_root/fest/methodology/README.md" "fest methodology README"
check_pair "$projects_root/fest/methodology/festivals/README.md" "$repo_root/fest/methodology/festivals/README.md" "fest festivals README"
check_pair "$projects_root/fest/docs/lifecycle.md" "$repo_root/fest/docs/lifecycle.md" "fest lifecycle"
check_pair "$projects_root/fest/embedded/docs/intro/intro.txt" "$repo_root/fest/embedded/docs/intro/intro.txt" "fest intro"
check_pair "$projects_root/fest/embedded/docs/understand/methodology.txt" "$repo_root/fest/embedded/docs/understand/methodology.txt" "fest understand methodology"
check_pair "$projects_root/fest/embedded/docs/understand/overview.txt" "$repo_root/fest/embedded/docs/understand/overview.txt" "fest understand overview"

if [[ "$failures" -gt 0 ]]; then
    echo "doc sync check failed: $failures drift issue(s) found" >&2
    exit 1
fi

echo "doc sync check passed"
