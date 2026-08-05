#!/usr/bin/env bash
# Checks that plugin command references match actual CLI help output.
# Run during development/CI to catch stale plugin content.

set -euo pipefail

PLUGIN_DIR="${1:-$(dirname "$0")/../..}"
PLUGIN_DIR="$(cd "$PLUGIN_DIR" && pwd)"
REPO_ROOT="$(cd "$PLUGIN_DIR/.." && pwd)"
ERRORS=0

resolve_cli() {
    local name="$1"
    local bundled=""

    case "$name" in
        fest) bundled="$REPO_ROOT/fest/bin/fest" ;;
        camp) bundled="$REPO_ROOT/camp/bin/camp" ;;
        *) return 1 ;;
    esac

    if [[ -x "$bundled" ]]; then
        printf '%s\n' "$bundled"
        return 0
    fi

    if command -v "$name" >/dev/null 2>&1; then
        command -v "$name"
        return 0
    fi

    return 1
}

FEST_BIN="${FEST_BIN:-$(resolve_cli fest || true)}"
CAMP_BIN="${CAMP_BIN:-$(resolve_cli camp || true)}"

check_command() {
    local cmd="$1"
    local subcmd="$2"
    local cli=""

    case "$cmd" in
        fest) cli="$FEST_BIN" ;;
        camp) cli="$CAMP_BIN" ;;
        *)
            echo "WARNING: unsupported CLI '$cmd' in plugin sync check" >&2
            ERRORS=$((ERRORS + 1))
            return
            ;;
    esac

    if [[ -z "$cli" ]]; then
        echo "WARNING: '$cmd' executable not found for plugin sync check" >&2
        ERRORS=$((ERRORS + 1))
        return
    fi

    if ! "$cli" help "$subcmd" >/dev/null 2>&1; then
        echo "WARNING: '$cmd $subcmd' not found in CLI — plugin may reference a removed command" >&2
        ERRORS=$((ERRORS + 1))
    fi
}

known_reference() {
    case "$1:$2" in
        fest:next|fest:validate|fest:commit|fest:status|fest:list|fest:show|fest:create|fest:task|fest:workflow|fest:link|fest:promote|fest:understand|fest:deps|fest:progress|fest:shell-init|fest:completion|fest:types|fest:links|fest:unlink|fest:scaffold)
            return 0
            ;;
        camp:init|camp:intent|camp:project|camp:go|camp:status|camp:shell-init|camp:p|camp:refs-sync|camp:pull|camp:push|camp:dungeon|camp:flow)
            return 0
            ;;
        camp:workitem|camp:list|camp:switch|camp:transfer)
            return 0
            ;;
    esac

    return 1
}

check_markdown_references() {
    local file line cmd subcmd

    while IFS= read -r file; do
        while IFS= read -r line; do
            if [[ "$line" =~ ^[[:space:]]*(fest|camp)[[:space:]]+([a-z][a-z-]*) ]]; then
                cmd="${BASH_REMATCH[1]}"
                subcmd="${BASH_REMATCH[2]}"

                if ! known_reference "$cmd" "$subcmd"; then
                    echo "WARNING: $file references '$cmd $subcmd' but sync-check.sh does not validate it" >&2
                    ERRORS=$((ERRORS + 1))
                fi
            fi
        done < "$file"
    done < <(find "$PLUGIN_DIR" -type f -name '*.md' | sort)
}

echo "Checking plugin commands against installed CLI..."

# fest commands referenced in plugin
for subcmd in next validate commit status list show create task workflow link promote understand deps progress shell-init completion types links unlink scaffold; do
    check_command fest "$subcmd"
done

# camp commands referenced in plugin
for subcmd in init intent project go status shell-init p refs-sync pull push dungeon flow workitem list switch transfer; do
    check_command camp "$subcmd"
done

check_markdown_references

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "${ERRORS} command(s) may be stale. Review claude-plugin/ for outdated references."
    exit 1
fi

echo "All referenced commands found in CLI. Plugin looks current."
