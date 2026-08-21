# Test commands

# Show available test commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Test all projects
[no-cd]
all: fest camp festival-installer release-operator release-notes plugin marketplace-publish completion-assets install-shell no-em-dash
    @echo "All tests passed"

# Fail if an em dash (U+2014) appears in tracked or untracked files this repo
# owns (still honors .gitignore). README.zh-CN.md is excluded: Chinese
# typography uses the em dash. docs/cli-reference/camp/ and .../fest/ are
# excluded: those pages mirror the pinned camp/fest submodules' own compiled
# help text, this repo does not own that content, and any local fix here
# would be silently reverted by the next `just docs all`.
[no-cd]
no-em-dash:
    #!/usr/bin/env bash
    set -euo pipefail
    hits="$(git grep -n --untracked $'\xe2\x80\x94' -- \
        '*.sh' '*.js' '*.mjs' '*.yaml' '*.yml' '*.just' '*.json' '*.go' 'justfile' \
        'README.md' 'CHANGELOG.md' \
        'docs/cli-reference/*.md' ':!docs/cli-reference/camp' ':!docs/cli-reference/fest' \
        || true)"
    if [ -n "$hits" ]; then
        echo "em dash (U+2014) found:" >&2
        echo "$hits" >&2
        echo "" >&2
        echo "This repo does not allow em dashes in these files. Use a colon, a comma, parentheses, or two sentences instead." >&2
        exit 1
    fi
    echo "no em dashes found"

# Check mirrored camp/fest doc copies against their source repos
[no-cd]
doc-sync:
    bash scripts/check-doc-sync.sh

# Verify bundled camp/fest submodules resolve from a clean module cache rather
# than inheriting whatever happens to already be installed on the host.
[no-cd]
bundled-module-resolution:
    go -C tools/release-operator run . check-bundled-modules --repo-root ../..

# Verify stable/dev CLI doc generation uses the intended command surface
[no-cd]
docs-profile:
    bash scripts/test_cli_docs_profile.sh

# Verify bundled camp/fest submodules are pinned to exact tags for the selected release channel
[no-cd]
release-pins mode="stable":
    bash scripts/check_release_channel_tags.sh "{{mode}}"

# Run the no-network beginner path smoke against repo-local camp and fest binaries
[no-cd]
beginner-path-smoke:
    bash scripts/smoke_beginner_path.sh

# Verify the marketplace publish path opens a pull request and never writes to main
[no-cd]
marketplace-publish:
    bash scripts/test_marketplace_publish.sh

# Verify packaged completion filenames come from scripts/completion-clis.txt
[no-cd]
completion-assets:
    bash scripts/test_completion_assets.sh

# Test fest
[no-cd]
fest:
    cd fest && just test all

# Test camp
[no-cd]
camp:
    cd camp && just test all

# Test the festival hub
[no-cd]
festival-installer:
    cd festival-installer && just test

# Test install.sh login-profile PATH writes (isolated HOME, no network)
[no-cd]
install-shell:
    bash scripts/test_install_shell.sh

# Test the release operator logic used by just release dev|rc|stable
[no-cd]
release-operator:
    cd tools/release-operator && go test ./...

# Test the release notes generator used to rewrite festival GitHub release bodies
[no-cd]
release-notes:
    cd tools/release-notes && go test ./...

# Test the Claude Code plugin bundle and hooks
[no-cd]
plugin:
    just plugin check
