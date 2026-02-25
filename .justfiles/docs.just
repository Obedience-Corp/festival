# Documentation management

docs_root := "docs/cli-reference"

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
    (cd fest && just build)
    mkdir -p {{docs_root}}/fest
    ./fest/bin/fest gendocs --output {{docs_root}}/fest --format markdown --single
    echo "fest docs generated"

# Generate camp CLI docs
[no-cd]
camp:
    #!/usr/bin/env bash
    set -euo pipefail
    (cd camp && just build)
    mkdir -p {{docs_root}}/camp
    ./camp/bin/camp gendocs --output {{docs_root}}/camp --format markdown --single
    echo "camp docs generated"

# Serve docs locally (localhost:8000)
[no-cd]
serve:
    uv run mkdocs serve
