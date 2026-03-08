#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
projects_root="$(cd "${repo_root}/.." && pwd)"

failures=0

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
        left_tmp="$(mktemp)"
        right_tmp="$(mktemp)"
        normalize_readme "$left" "$left_tmp"
        normalize_readme "$right" "$right_tmp"
        left_cmp="$left_tmp"
        right_cmp="$right_tmp"
    fi

    if ! diff -u "$left_cmp" "$right_cmp"; then
        echo "doc sync drift: $label" >&2
        failures=$((failures + 1))
    fi

    if [[ -n "$left_tmp" ]]; then
        rm -f "$left_tmp"
    fi
    if [[ -n "$right_tmp" ]]; then
        rm -f "$right_tmp"
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
check_pair "$projects_root/fest/embedded/docs/understand/methodology.txt" "$repo_root/fest/embedded/docs/understand/methodology.txt" "fest understand methodology"
check_pair "$projects_root/fest/embedded/docs/understand/overview.txt" "$repo_root/fest/embedded/docs/understand/overview.txt" "fest understand overview"

if [[ "$failures" -gt 0 ]]; then
    echo "doc sync check failed: $failures drift issue(s) found" >&2
    exit 1
fi

echo "doc sync check passed"
