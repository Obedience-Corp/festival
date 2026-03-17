#!/usr/bin/env just --justfile
# Claude Code plugin management

[private]
default:
    @just --list --justfile {{source_file()}}

# Check plugin commands match installed CLI
check:
    #!/usr/bin/env bash
    PLUGIN="$(cd "$(dirname "{{source_file()}}")/.." && pwd)/claude-plugin"
    bash "$PLUGIN/hooks/scripts/sync-check.sh"

# List all plugin components
list:
    #!/usr/bin/env bash
    PLUGIN="$(cd "$(dirname "{{source_file()}}")/.." && pwd)/claude-plugin"
    echo "Commands:"
    ls -1 "$PLUGIN"/commands/*.md 2>/dev/null | sed 's|.*/||;s|\.md$||' | sed 's/^/  /'
    echo ""
    echo "Skills:"
    ls -1d "$PLUGIN"/skills/*/ 2>/dev/null | sed 's|.*/\(.*\)/|\1|' | sed 's/^/  /'
    echo ""
    echo "Agents:"
    ls -1 "$PLUGIN"/agents/*.md 2>/dev/null | sed 's|.*/||;s|\.md$||' | sed 's/^/  /'
