# Documentation management

docs_root := env("CLI_DOCS_ROOT", "docs/cli-reference")
cli_profile := env("CLI_PROFILE", "stable")
cli_release_channel := env("CLI_RELEASE_CHANNEL", "")
base_url := env("HUGO_BASEURL", "https://fest.build")

# Show available docs commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Generate docs for all CLIs
[no-cd]
all: fest camp
    @echo "All CLI docs generated in {{docs_root}}/"

# Generate fest CLI docs
[no-cd]
fest:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "{{cli_release_channel}}" ]; then
        bash scripts/check_release_channel_tags.sh "{{cli_release_channel}}"
    fi
    fest_gendocs_flags=()
    case "{{cli_profile}}" in
        stable)
            (cd fest && just build quick-stable)
            if ./fest/bin/fest gendocs --help 2>&1 | grep -q -- '--stable'; then
                fest_gendocs_flags+=(--stable)
            fi
            ;;
        dev) (cd fest && just build quick-dev) ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac
    mkdir -p {{docs_root}}/fest
    ./fest/bin/fest gendocs --output {{docs_root}}/fest --format markdown --single "${fest_gendocs_flags[@]}"
    echo "fest docs generated"

# Generate camp CLI docs
[no-cd]
camp:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "{{cli_release_channel}}" ]; then
        bash scripts/check_release_channel_tags.sh "{{cli_release_channel}}"
    fi
    case "{{cli_profile}}" in
        stable) (cd camp && just build quick-stable) ;;
        dev) (cd camp && just build quick-dev) ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac
    mkdir -p {{docs_root}}/camp
    ./camp/bin/camp gendocs --output {{docs_root}}/camp --format markdown --single
    echo "camp docs generated"

# Serve docs locally with live reload
[no-cd]
serve:
    hugo server -D --source .

# Build docs for production (override domain: HUGO_BASEURL="https://example.com" just docs build)
[no-cd]
build:
    hugo --minify --source . --baseURL "{{base_url}}"
    npx pagefind --site public

# Index docs for search (run after 'just docs build' or for local dev)
[no-cd]
index:
    hugo --minify --source .
    npx pagefind --site public
