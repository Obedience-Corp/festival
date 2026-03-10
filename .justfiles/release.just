# Release management
# Three channels:
# - dev: moving prerelease from develop
# - rc: release candidate prerelease
# - stable: public release

subs := "fest camp"

# Show available release commands
[private]
default:
    @just --list --unsorted --justfile {{source_file()}}

[private]
[no-cd]
pin-from-latest mode="stable":
    #!/usr/bin/env bash
    set -euo pipefail

    mode="{{mode}}"
    case "${mode}" in
        stable|rc|dev) ;;
        *)
            echo "ERROR: mode must be 'stable', 'rc', or 'dev' (got: ${mode})"
            exit 1
            ;;
    esac

    if [ -n "$(git status --porcelain)" ]; then
        echo "ERROR: festival repo has uncommitted changes."
        echo "Commit/stash first, then rerun."
        exit 1
    fi

    git fetch --tags
    git -C fest fetch --tags
    git -C camp fetch --tags

    latest_tag() {
        repo="$1"
        tag_mode="$2"
        local pattern=""
        case "${tag_mode}" in
            stable) pattern='^v[0-9]+(\.[0-9]+)*$' ;;
            rc) pattern='^v[0-9]+(\.[0-9]+)*-rc\.[0-9]+$' ;;
            dev) pattern='^v[0-9]+(\.[0-9]+)*-dev\.[0-9]+$' ;;
        esac
        git -C "${repo}" tag -l 'v*' --sort=-v:refname | grep -E "${pattern}" | head -1 || true
    }

    fest_tag="$(latest_tag fest "${mode}")"
    camp_tag="$(latest_tag camp "${mode}")"

    if [ -z "${fest_tag}" ] || [ -z "${camp_tag}" ]; then
        echo "ERROR: Missing ${mode} tags."
        echo "fest latest ${mode}: ${fest_tag:-<none>}"
        echo "camp latest ${mode}: ${camp_tag:-<none>}"
        if [ "${mode}" = "stable" ]; then
            echo "For a first release, run:"
            echo "  just release draft-bootstrap <festival_version> <fest_version> <camp_version>"
        elif [ "${mode}" = "rc" ]; then
            echo "Create rc tags in fest/camp first, then rerun with mode=rc."
        else
            echo "Create dev tags in fest/camp first, then rerun with mode=dev."
        fi
        exit 1
    fi

    git -C fest checkout --detach "${fest_tag}"
    git -C camp checkout --detach "${camp_tag}"
    # Stages submodule pointer updates; caller decides whether and when to commit them.
    git add fest camp

    echo "Pinned fest to: ${fest_tag}"
    echo "Pinned camp to: ${camp_tag}"

# Pin submodules to latest stable tags without creating a festival release
[no-cd]
refresh-stable:
    just --justfile {{source_file()}} pin-from-latest stable

# Pin submodules to latest rc tags without creating a festival release
[no-cd]
refresh-rc:
    just --justfile {{source_file()}} pin-from-latest rc

# Pin submodules to latest dev/prerelease tags without creating a festival release
[no-cd]
refresh-dev:
    just --justfile {{source_file()}} pin-from-latest dev

# Pre-release checks: show submodule versions, dirty state, and build validation
[no-cd]
preflight mode="stable":
    #!/usr/bin/env bash
    set -euo pipefail
    build_profile="stable"
    if [ "{{mode}}" = "dev" ]; then
        build_profile="dev"
    fi
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

    if [ -n "$(git status --porcelain)" ]; then
        echo "ERROR: festival repo has uncommitted changes"
        git status --short
        echo "Commit/stash first, then rerun."
        exit 1
    fi

    echo "Checking tagged release pins:"
    just test release-pins "{{mode}}"
    echo ""

    echo "Checking mirrored docs:"
    just test doc-sync
    echo ""

    echo "Checking stable/dev docs profile:"
    just test docs-profile
    echo ""

    echo "Building CLIs:"
    CLI_PROFILE="${build_profile}" just build all
    echo ""

    echo "Beginner-path smoke:"
    just test beginner-path-smoke
    echo ""

    # Show existing tags for context
    echo "Recent tags:"
    git tag -l --sort=-v:refname | head -5 || echo "  (none)"
    echo ""
    echo "Preflight complete. Run 'just release draft <version>', 'just release draft-rc <version> <n>', or 'just release draft-dev <version> <n>' to proceed."

# Run GoReleaser dry run (no publish)
[no-cd]
dry-run:
    goreleaser release --snapshot --clean --skip=publish,announce

# First stable release bootstrap:
# - create/push fest + camp stable tags at their current HEAD
# - pin festival submodules to those tags
# - commit/push submodule pointer update
# - create/push festival stable tag
[no-cd]
[confirm("This will create and push fest/camp tags, then create and push a STABLE festival release tag. Continue?")]
draft-bootstrap version fest_version camp_version:
    #!/usr/bin/env bash
    set -euo pipefail

    release_tag="v{{version}}"
    fest_tag="v{{fest_version}}"
    camp_tag="v{{camp_version}}"

    # Require clean festival working tree for safe release automation.
    if [ -n "$(git status --porcelain)" ]; then
        echo "ERROR: festival repo has uncommitted changes."
        echo "Commit/stash first, then rerun."
        exit 1
    fi

    # Fetch latest refs for root + submodules.
    git fetch --tags
    git -C fest fetch --tags
    git -C camp fetch --tags

    # Ensure requested tags don't already exist locally or remotely.
    for pair in "fest:${fest_tag}" "camp:${camp_tag}"; do
        repo="${pair%%:*}"
        tag="${pair##*:}"
        if git -C "${repo}" rev-parse -q --verify "refs/tags/${tag}" >/dev/null; then
            echo "ERROR: ${repo} tag ${tag} already exists locally."
            echo "Use 'just release draft-from-latest <version>' if tags already exist."
            exit 1
        fi
        if [ -n "$(git -C "${repo}" ls-remote --tags origin "refs/tags/${tag}")" ]; then
            echo "ERROR: ${repo} tag ${tag} already exists on origin."
            echo "Use 'just release draft-from-latest <version>' if tags already exist."
            exit 1
        fi
    done

    # Create and push stable tags in submodules at current HEAD.
    git -C fest tag -a "${fest_tag}" -m "Release ${fest_tag}"
    git -C fest push origin "${fest_tag}"

    git -C camp tag -a "${camp_tag}" -m "Release ${camp_tag}"
    git -C camp push origin "${camp_tag}"

    # Pin submodules to the tags just created.
    git -C fest checkout --detach "${fest_tag}"
    git -C camp checkout --detach "${camp_tag}"
    CLI_RELEASE_CHANNEL=stable just docs all
    git add fest camp content/docs/cli-reference

    # Commit and push submodule pointer changes.
    if git diff --cached --quiet -- fest camp content/docs/cli-reference; then
        echo "Submodule pointers and docs already match ${fest_tag}/${camp_tag}; no release commit needed."
    else
        git commit -m "Release: pin fest ${fest_tag} and camp ${camp_tag}"
        git push origin HEAD
    fi

    # Ensure the festival release tag doesn't already exist.
    if git rev-parse -q --verify "refs/tags/${release_tag}" >/dev/null; then
        echo "ERROR: festival tag ${release_tag} already exists locally."
        exit 1
    fi
    if [ -n "$(git ls-remote --tags origin "refs/tags/${release_tag}")" ]; then
        echo "ERROR: festival tag ${release_tag} already exists on origin."
        exit 1
    fi

    # Final preflight and release tag push (triggers CI release workflow).
    just release preflight

    echo ""
    echo "=== Creating stable release ${release_tag} ==="
    git tag -a "${release_tag}" -m "Release ${release_tag}"
    git push origin "${release_tag}"
    echo ""
    echo "Stable release ${release_tag} pushed."
    echo "fest pinned to: ${fest_tag}"
    echo "camp pinned to: ${camp_tag}"
    echo "Monitor: gh run watch --repo Obedience-Corp/festival"

# Unified release automation from latest submodule tags:
# - mode=stable: latest stable tags (vX.Y.Z)
# - mode=rc: latest rc tags (vX.Y.Z-rc.N)
# - mode=dev: latest dev tags (vX.Y.Z-dev.N)
# - pin submodules, refresh docs, commit/push pointer update if needed
# - create/push festival release tag for the selected channel
[no-cd]
[confirm("This will pin fest/camp to latest tags for the selected mode and create/push a festival release tag. Continue?")]
draft-from-latest version mode="stable" n="1":
    #!/usr/bin/env bash
    set -euo pipefail

    mode="{{mode}}"
    case "${mode}" in
        stable|rc|dev) ;;
        *)
            echo "ERROR: mode must be 'stable', 'rc', or 'dev' (got: ${mode})"
            exit 1
            ;;
    esac

    case "${mode}" in
        stable)
            release_tag="v{{version}}"
            docs_cmd="CLI_RELEASE_CHANNEL=stable just docs all"
            release_label="stable"
            ;;
        rc)
            release_tag="v{{version}}-rc.{{n}}"
            docs_cmd="CLI_RELEASE_CHANNEL=rc just docs all"
            release_label="rc"
            ;;
        dev)
            release_tag="v{{version}}-dev.{{n}}"
            docs_cmd="CLI_PROFILE=dev CLI_RELEASE_CHANNEL=dev just docs all"
            release_label="dev"
            ;;
    esac

    just --justfile {{source_file()}} pin-from-latest "${mode}"
    eval "${docs_cmd}"
    git add fest camp content/docs/cli-reference

    fest_tag="$(cd fest && git describe --tags --exact-match HEAD 2>/dev/null || true)"
    camp_tag="$(cd camp && git describe --tags --exact-match HEAD 2>/dev/null || true)"

    if [ -z "${fest_tag}" ] || [ -z "${camp_tag}" ]; then
        echo "ERROR: Submodules are not pinned to exact ${mode} tags after refresh."
        exit 1
    fi

    if git diff --cached --quiet -- fest camp content/docs/cli-reference; then
        echo "Submodule pointers and docs already at fest=${fest_tag}, camp=${camp_tag}; no release commit needed."
    else
        git commit -m "Release: pin fest ${fest_tag} and camp ${camp_tag}"
        git push origin HEAD
    fi

    if git rev-parse -q --verify "refs/tags/${release_tag}" >/dev/null; then
        echo "ERROR: festival tag ${release_tag} already exists locally."
        exit 1
    fi
    if [ -n "$(git ls-remote --tags origin "refs/tags/${release_tag}")" ]; then
        echo "ERROR: festival tag ${release_tag} already exists on origin."
        exit 1
    fi

    just release preflight "${mode}"

    echo ""
    echo "=== Creating ${release_label} release ${release_tag} ==="
    git tag -a "${release_tag}" -m "Release ${release_tag}"
    git push origin "${release_tag}"
    echo ""
    echo "${release_label} release ${release_tag} pushed."
    echo "fest pinned to: ${fest_tag}"
    echo "camp pinned to: ${camp_tag}"
    echo "Monitor: gh run watch --repo Obedience-Corp/festival"

# Draft a stable release: preflight + tag + push (triggers CI)
[no-cd]
[confirm("This will create and push a STABLE release tag. Continue?")]
draft version:
    #!/usr/bin/env bash
    set -euo pipefail

    # Run preflight
    just release preflight stable

    echo ""
    echo "=== Creating stable release v{{version}} ==="
    git tag -a "v{{version}}" -m "Release v{{version}}"
    git push origin "v{{version}}"
    echo ""
    echo "Stable release v{{version}} pushed. CI will build and publish."
    echo "Monitor: gh run watch --repo Obedience-Corp/festival"

# Draft an RC release: preflight + rc tag + push (triggers CI, marked as prerelease)
[no-cd]
[confirm("This will create and push an RC release tag. Continue?")]
draft-rc version n="1":
    #!/usr/bin/env bash
    set -euo pipefail

    just release preflight rc

    tag="v{{version}}-rc.{{n}}"
    echo ""
    echo "=== Creating rc release ${tag} ==="
    git tag -a "${tag}" -m "RC release ${tag}"
    git push origin "${tag}"
    echo ""
    echo "RC release ${tag} pushed. CI will build and publish as prerelease."
    echo "Monitor: gh run watch --repo Obedience-Corp/festival"

# Draft a dev release: preflight + dev tag + push (triggers CI, marked as prerelease)
[no-cd]
[confirm("This will create and push a DEV release tag. Continue?")]
draft-dev version n="1":
    #!/usr/bin/env bash
    set -euo pipefail

    just release preflight dev

    tag="v{{version}}-dev.{{n}}"
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
