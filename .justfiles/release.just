# Release management

subs := "fest camp"

# Show available release commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

# Pre-release checks: show submodule versions, dirty state, and build validation
[no-cd]
preflight:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "=== Release Preflight ==="
    echo ""

    # Check submodule versions
    echo "Submodule pins:"
    for sub in {{subs}}; do
        if [ -d "$sub" ]; then
            sha=$(cd "$sub" && git rev-parse --short HEAD)
            tag=$(cd "$sub" && git describe --tags --exact-match HEAD 2>/dev/null || echo "no tag")
            branch=$(cd "$sub" && git rev-parse --abbrev-ref HEAD)
            echo "  $sub: $sha ($tag) [branch: $branch]"
        fi
    done
    echo ""

    # Check for dirty submodules
    dirty=0
    for sub in {{subs}}; do
        if [ -d "$sub" ]; then
            if [ -n "$(cd "$sub" && git status --porcelain)" ]; then
                echo "  WARNING: $sub has uncommitted changes"
                dirty=1
            fi
        fi
    done
    if [ $dirty -eq 0 ]; then
        echo "Submodules: clean"
    else
        echo ""
        echo "ERROR: Dirty submodules. Commit or stash changes before releasing."
        exit 1
    fi
    echo ""

    # Check festival repo itself
    if [ -n "$(git status --porcelain)" ]; then
        echo "WARNING: festival repo has uncommitted changes"
        git status --short
        echo ""
    fi

    # Show existing tags for context
    echo "Recent tags:"
    git tag -l --sort=-v:refname | head -5 || echo "  (none)"
    echo ""
    echo "Preflight complete. Run 'just release draft <version>' or 'just release draft-dev <version>' to proceed."

# Run GoReleaser dry run (no publish)
[no-cd]
dry-run:
    goreleaser release --snapshot --clean --skip=publish,announce

# Draft a stable release: preflight + tag + push (triggers CI)
[no-cd]
[confirm("This will create and push a STABLE release tag. Continue?")]
draft version:
    #!/usr/bin/env bash
    set -euo pipefail

    # Run preflight
    just release preflight

    echo ""
    echo "=== Creating stable release v{{version}} ==="
    git tag -a "v{{version}}" -m "Release v{{version}}"
    git push origin "v{{version}}"
    echo ""
    echo "Stable release v{{version}} pushed. CI will build and publish."
    echo "Monitor: gh run watch --repo Obedience-Corp/festival"

# Draft a dev/prerelease: preflight + rc tag + push (triggers CI, marked as prerelease)
[no-cd]
[confirm("This will create and push a DEV/prerelease tag. Continue?")]
draft-dev version rc="1":
    #!/usr/bin/env bash
    set -euo pipefail

    # Run preflight
    just release preflight

    tag="v{{version}}-rc.{{rc}}"
    echo ""
    echo "=== Creating dev release ${tag} ==="
    git tag -a "${tag}" -m "Dev release ${tag}"
    git push origin "${tag}"
    echo ""
    echo "Dev release ${tag} pushed. CI will build and publish as prerelease."
    echo "Monitor: gh run watch --repo Obedience-Corp/festival"
    echo ""
    echo "To clean up later:"
    echo "  gh release delete ${tag} --repo Obedience-Corp/festival --yes"
    echo "  git push origin --delete ${tag} && git tag -d ${tag}"

# Clean up a release (delete tag + GitHub release)
[no-cd]
[confirm("This will delete the GitHub release and tag. Continue?")]
cleanup tag:
    #!/usr/bin/env bash
    set -euo pipefail
    echo "Deleting GitHub release {{tag}}..."
    gh release delete "{{tag}}" --repo Obedience-Corp/festival --yes 2>/dev/null || echo "  No GitHub release found for {{tag}}"
    echo "Deleting remote tag {{tag}}..."
    git push origin --delete "{{tag}}" 2>/dev/null || echo "  Remote tag not found"
    echo "Deleting local tag {{tag}}..."
    git tag -d "{{tag}}" 2>/dev/null || echo "  Local tag not found"
    echo "Cleanup complete."

# Full release (CI should handle this, but for manual use)
[no-cd]
publish:
    goreleaser release --clean
