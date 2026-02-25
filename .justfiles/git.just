# Git commands

subs := "fest camp"

# Show available git commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Show status of repo and submodules
[no-cd]
status:
    #!/usr/bin/env bash
    echo "=== Festival Status ==="
    git status --short
    echo ""
    echo "=== Submodule Status ==="
    git submodule status

# Commit festival repo changes
[no-cd]
commit message:
    git commit -m "{{message}}"

# Push to remote
[no-cd]
push:
    git push -u origin HEAD

# Pull and update submodules
[no-cd]
pull:
    git pull
    git submodule update --remote --merge
    @echo "Pulled and updated submodules"

# Show recent commits across all repos
[no-cd]
log:
    #!/usr/bin/env bash
    echo "=== Festival ==="
    git log --oneline -5
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            echo ""
            echo "=== $sub ==="
            (cd $sub && git log --oneline -5)
        fi
    done

# Show diff
[no-cd]
diff:
    git diff

# Show diff for specific submodule
[no-cd]
diff-sub name:
    cd {{name}} && git diff
