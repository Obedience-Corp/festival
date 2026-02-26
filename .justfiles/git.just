# Git commands for festival repo management

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

# Add all changes (repo + submodules)
[no-cd]
add-all:
    git add .
    @echo "Staged all changes"

# Commit festival repo changes
[no-cd]
commit message:
    git commit -m "{{message}}"

# Commit changes in a specific submodule
[no-cd]
commit-sub name message:
    cd {{name}} && git add . && git commit -m "{{message}}"
    @echo "Committed in {{name}}"

# Commit staged changes in all submodules with the same message
[no-cd]
commit-all message:
    #!/usr/bin/env bash
    echo "Committing in submodules..."
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            if (cd $sub && git diff --cached --quiet); then
                echo "  $sub: nothing staged"
            else
                echo "  Committing in $sub..."
                (cd $sub && git commit -m "{{message}}")
            fi
        fi
    done
    echo "All submodules committed"

# Push festival repo
[no-cd]
push:
    git push -u origin HEAD

# Push all submodules then festival repo
[no-cd]
push-all:
    #!/usr/bin/env bash
    echo "Pushing submodules..."
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            echo "  Pushing $sub..."
            (cd $sub && git push -u origin HEAD 2>/dev/null) || echo "  $sub: nothing to push or not configured"
        fi
    done
    echo ""
    echo "Pushing festival..."
    git push -u origin HEAD
    echo "All pushed"

# Pull and update submodules
[no-cd]
pull:
    git pull
    git submodule update --remote --merge
    @echo "Pulled and updated submodules"

# Sync all submodules to latest main from origin
[no-cd]
sync:
    #!/usr/bin/env bash
    echo "Syncing submodules to latest main..."
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            echo "  Syncing $sub..."
            (cd $sub && git checkout main && git pull origin main) || echo "  $sub: sync failed"
        fi
    done
    echo "All submodules synced to main"

# Create a branch in repo and all submodules
[no-cd]
branch-all name:
    #!/usr/bin/env bash
    echo "Creating branch '{{name}}' everywhere..."
    git checkout -b {{name}}
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            (cd $sub && git checkout -b {{name}} 2>/dev/null) || echo "  $sub: branch may already exist"
        fi
    done
    echo "Branch '{{name}}' created"

# Switch branch in repo and all submodules
[no-cd]
checkout-all branch:
    #!/usr/bin/env bash
    echo "Switching to branch '{{branch}}' everywhere..."
    git checkout {{branch}}
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            (cd $sub && git checkout {{branch}} 2>/dev/null) || echo "  $sub: branch may not exist"
        fi
    done
    echo "Switched to '{{branch}}'"

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

# Stash changes in all repos
[no-cd]
stash-all:
    #!/usr/bin/env bash
    echo "Stashing changes everywhere..."
    git stash
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            (cd $sub && git stash 2>/dev/null) || true
        fi
    done
    echo "Stashed all changes"

# Pop stash in all repos
[no-cd]
stash-pop-all:
    #!/usr/bin/env bash
    echo "Popping stash everywhere..."
    git stash pop 2>/dev/null || true
    for sub in {{subs}}; do
        if [ -d "$sub/.git" ] || [ -f "$sub/.git" ]; then
            (cd $sub && git stash pop 2>/dev/null) || true
        fi
    done
    echo "Popped all stashes"
