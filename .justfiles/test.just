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

# Test fest
[no-cd]
fest:
    cd fest && just test all

# Test camp
[no-cd]
camp:
    cd camp && just test all
