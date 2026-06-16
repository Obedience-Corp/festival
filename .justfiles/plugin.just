#!/usr/bin/env just --justfile
# Claude Code plugin management

[private]
default:
    @just --list --justfile {{source_file()}}

# Generate per-harness targets from claude-plugin/ (single source of truth)
generate:
    #!/usr/bin/env bash
    set -euo pipefail
    ROOT="$(cd "$(dirname "{{source_file()}}")/.." && pwd)"
    node "$ROOT/packaging/generate.mjs"

# Check plugin commands match installed CLI
check:
    #!/usr/bin/env bash
    ROOT="$(cd "$(dirname "{{source_file()}}")/.." && pwd)"
    bash "$ROOT/scripts/test_claude_plugin.sh"

# Dry-run each target's distribution surface (no live push)
dist-check:
    #!/usr/bin/env bash
    ROOT="$(cd "$(dirname "{{source_file()}}")/.." && pwd)"
    bash "$ROOT/packaging/scripts/distribution-dry-run.sh"

# Bump the plugin version across plugin.json, marketplace.json, and all generated targets
bump version:
    #!/usr/bin/env bash
    set -euo pipefail
    ROOT="$(cd "$(dirname "{{source_file()}}")/.." && pwd)"
    if ! printf '%s' "{{version}}" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+$'; then
        echo "version must be semver (got: {{version}})" >&2
        exit 1
    fi
    for f in "$ROOT/claude-plugin/.claude-plugin/plugin.json" "$ROOT/.claude-plugin/marketplace.json"; do
        node -e '
    const fs = require("fs");
    const file = process.argv[1];
    const v = process.argv[2];
    const j = JSON.parse(fs.readFileSync(file, "utf8"));
    if (Array.isArray(j.plugins)) { j.plugins[0].version = v; } else { j.version = v; }
    fs.writeFileSync(file, JSON.stringify(j, null, 2) + "\n");
    ' "$f" "{{version}}"
    done
    node "$ROOT/packaging/generate.mjs" >/dev/null
    echo "Bumped plugin to {{version}} (plugin.json, marketplace.json, generated targets)"

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
