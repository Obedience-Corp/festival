# Submodule management

subs := "fest camp"

# Show available submodule commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Initialize submodules (after fresh clone)
[no-cd]
init:
    git submodule update --init --recursive
    @echo "Submodules initialized"

# Update all submodules to latest from remote
[no-cd]
update:
    git submodule update --remote --merge
    @echo "Submodules updated"

# Update specific submodule
[no-cd]
update-one name:
    cd {{name}} && git pull origin main
    git add {{name}}
    @echo "Updated {{name}}"

# Show status of all submodules
[no-cd]
status:
    git submodule status

# Pull changes in all submodules
[no-cd]
pull:
    git submodule foreach 'git pull origin main || true'
    @echo "Pulled latest in all submodules"

# Sync submodule URLs (after .gitmodules change)
[no-cd]
sync:
    git submodule sync --recursive
    @echo "Submodule URLs synced"

# Check for uncommitted changes in submodules
[no-cd]
dirty:
    #!/usr/bin/env bash
    dirty=0
    for sub in {{subs}}; do
        if [ -d "$sub" ]; then
            if [ -n "$(cd $sub && git status --porcelain)" ]; then
                echo "  $sub: has uncommitted changes"
                dirty=1
            fi
        fi
    done
    if [ $dirty -eq 0 ]; then
        echo "All submodules clean"
    fi
