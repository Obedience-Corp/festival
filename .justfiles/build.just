# Build commands

# Show available build commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Build both CLIs
[no-cd]
all: fest camp
    @echo "Both CLIs built"

# Build fest
[no-cd]
fest:
    cd fest && just build

# Build camp
[no-cd]
camp:
    cd camp && just build
