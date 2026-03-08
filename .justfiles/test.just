# Test commands

# Show available test commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Test all projects
[no-cd]
all: fest camp
    @echo "All tests passed"

# Check mirrored camp/fest doc copies against their source repos
[no-cd]
doc-sync:
    bash scripts/check-doc-sync.sh

# Test fest
[no-cd]
fest:
    cd fest && just test all

# Test camp
[no-cd]
camp:
    cd camp && just test all
