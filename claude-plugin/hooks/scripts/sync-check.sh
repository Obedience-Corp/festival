#!/usr/bin/env bash
# Checks that plugin command references match actual CLI help output.
# Run during development/CI to catch stale plugin content.

set -euo pipefail

PLUGIN_DIR="${1:-$(dirname "$0")/../..}"
ERRORS=0

check_command() {
    local cmd="$1"
    local subcmd="$2"

    if ! $cmd help "$subcmd" >/dev/null 2>&1; then
        echo "WARNING: '$cmd $subcmd' not found in CLI — plugin may reference a removed command" >&2
        ERRORS=$((ERRORS + 1))
    fi
}

echo "Checking plugin commands against installed CLI..."

# fest commands referenced in plugin
for subcmd in next validate commit status list show create task workflow link promote understand; do
    check_command fest "$subcmd"
done

# camp commands referenced in plugin
for subcmd in init intent project go status; do
    check_command camp "$subcmd"
done

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "${ERRORS} command(s) may be stale. Review claude-plugin/ for outdated references."
    exit 1
fi

echo "All referenced commands found in CLI. Plugin looks current."
