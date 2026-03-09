# Documentation management

docs_root := env("CLI_DOCS_ROOT", "content/docs/cli-reference")
cli_profile := env("CLI_PROFILE", "stable")
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
    case "{{cli_profile}}" in
        stable) (cd fest && BUILD_TAGS='' just build) ;;
        dev) (cd fest && BUILD_TAGS=dev just build) ;;
        *)
            echo "ERROR: CLI_PROFILE must be 'stable' or 'dev' (got: {{cli_profile}})"
            exit 1
            ;;
    esac
    mkdir -p {{docs_root}}/fest
    ./fest/bin/fest gendocs --output {{docs_root}}/fest --format markdown --single
    echo "fest docs generated"

# Generate camp CLI docs
[no-cd]
camp:
    #!/usr/bin/env bash
    set -euo pipefail
    case "{{cli_profile}}" in
        stable) (cd camp && BUILD_TAGS='' just build) ;;
        dev) (cd camp && BUILD_TAGS=dev just build) ;;
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
