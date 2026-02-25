# Test commands

# Show available test commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Test all projects
[no-cd]
all: fest camp
    @echo "All tests passed"

# Test fest
[no-cd]
fest:
    cd fest && just test all

# Test camp
[no-cd]
camp:
    cd camp && just test all
