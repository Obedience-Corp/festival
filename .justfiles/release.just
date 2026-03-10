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

[private]
[no-cd]
require-homebrew-token:
    #!/usr/bin/env bash
    set -euo pipefail

    if ! command -v gh >/dev/null 2>&1; then
        echo "ERROR: gh is required to verify stable Homebrew publishing readiness."
        exit 1
    fi

    if ! gh auth status >/dev/null 2>&1; then
        echo "ERROR: gh is not authenticated."
        echo "Authenticate with: gh auth login"
        exit 1
    fi

    if ! gh secret list --repo Obedience-Corp/festival | awk '{print $1}' | grep -qx 'HOMEBREW_TAP_GITHUB_TOKEN'; then
        echo "ERROR: HOMEBREW_TAP_GITHUB_TOKEN is not configured for Obedience-Corp/festival."
        echo "Stable release would fail when publishing the Homebrew formula."
        echo "Add it with:"
        echo "  gh secret set HOMEBREW_TAP_GITHUB_TOKEN --repo Obedience-Corp/festival"
        exit 1
    fi

    echo "Homebrew publish token is configured."

# Show operator-facing release readiness for current branch and latest tags
[no-cd]
status:
    #!/usr/bin/env bash
    set -euo pipefail

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

    git fetch --tags >/dev/null 2>&1 || true
    git -C fest fetch --tags >/dev/null 2>&1 || true
    git -C camp fetch --tags >/dev/null 2>&1 || true

    echo "festival branch: $(git rev-parse --abbrev-ref HEAD)"
    echo ""
    echo "Current submodule pins:"
    for sub in {{subs}}; do
        sha=$(cd "$sub" && git rev-parse --short HEAD)
        tag=$(cd "$sub" && git describe --tags --exact-match HEAD 2>/dev/null || echo "no tag")
        echo "  $sub: $sha ($tag)"
    done
    echo ""
    echo "Latest available tags:"
    for mode in stable rc dev; do
        echo "  ${mode}: fest=$(latest_tag fest "$mode" || true) camp=$(latest_tag camp "$mode" || true)"
    done
    echo ""
    if gh auth status >/dev/null 2>&1 && gh secret list --repo Obedience-Corp/festival 2>/dev/null | awk '{print $1}' | grep -qx 'HOMEBREW_TAP_GITHUB_TOKEN'; then
        echo "Homebrew stable publish: configured"
    else
        echo "Homebrew stable publish: missing HOMEBREW_TAP_GITHUB_TOKEN"
    fi

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

    if [ "{{mode}}" = "stable" ]; then
        echo "Checking stable publisher secrets:"
        just --justfile {{source_file()}} require-homebrew-token
        echo ""
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
    echo "Preflight complete."
    echo "  One-command: just release go <dev|rc|stable> <festival-version> [n]"
    echo "  Manual:      just release draft <version> | draft-rc <version> <n> | draft-dev <version> <n>"

# One-command bundled release from the latest already-created camp/fest tags.
# This does not create camp/fest tags. Those repos own their own versions.
[no-cd]
go channel version="" n="" level="":
    #!/usr/bin/env bash
    set -euo pipefail

    channel="{{channel}}"
    version="{{version}}"
    n="{{n}}"

    # --- helpers ---

    latest_tag_for_repo() {
        local repo="$1" mode="$2" pattern=""
        case "${mode}" in
            stable) pattern='^v[0-9]+(\.[0-9]+)*$' ;;
            rc)     pattern='^v[0-9]+(\.[0-9]+)*-rc\.[0-9]+$' ;;
            dev)    pattern='^v[0-9]+(\.[0-9]+)*-dev\.[0-9]+$' ;;
        esac
        git -C "${repo}" tag -l 'v*' --sort=-v:refname | grep -E "${pattern}" | head -1 || true
    }

    case "${channel}" in
        dev|rc|stable) ;;
        *) echo "ERROR: channel must be 'dev', 'rc', or 'stable' (got: ${channel})"; exit 1 ;;
    esac

    if [ -n "{{level}}" ]; then
        echo "ERROR: 'level' is not supported here."
        echo "Create camp/fest dev releases in their own repos first, then run:"
        echo "  just release go dev <festival-version> <n>"
        exit 1
    fi

    if [ -n "$(git status --porcelain)" ]; then
        echo "ERROR: festival repo has uncommitted changes."
        echo "Commit/stash first, then rerun."
        exit 1
    fi

    for sub in fest camp; do
        if [ -n "$(git -C "${sub}" status --porcelain)" ]; then
            echo "ERROR: ${sub} has uncommitted changes."
            exit 1
        fi
    done

    # --- fetch ---

    echo "Fetching tags..."
    git fetch --tags >/dev/null 2>&1
    git -C fest fetch --tags >/dev/null 2>&1
    git -C camp fetch --tags >/dev/null 2>&1

    echo ""
    echo "== Current State =="
    echo "  festival branch: $(git rev-parse --abbrev-ref HEAD)"
    echo "  fest latest dev:    $(latest_tag_for_repo fest dev)"
    echo "  camp latest dev:    $(latest_tag_for_repo camp dev)"
    echo "  fest latest rc:     $(latest_tag_for_repo fest rc)"
    echo "  camp latest rc:     $(latest_tag_for_repo camp rc)"
    echo "  fest latest stable: $(latest_tag_for_repo fest stable)"
    echo "  camp latest stable: $(latest_tag_for_repo camp stable)"
    echo ""

    case "${channel}" in
        dev)
            if [ -z "${version}" ]; then
                echo "ERROR: festival dev release requires an explicit festival version."
                echo "Usage: just release go dev <festival-version> [n]"
                exit 1
            fi
            if [ -z "${n}" ]; then
                existing="$(git tag -l "v${version}-dev.*" --sort=-v:refname | head -1 || true)"
                if [ -n "${existing}" ]; then
                    prev_n="${existing##*-dev.}"
                    n=$((prev_n + 1))
                else
                    n=1
                fi
                echo "Auto-detected festival dev N=${n}"
            fi

            echo "== Dev Bundle Release =="
            echo "Using latest already-created dev tags from camp and fest."
            echo ""
            echo "=== Festival: draft-dev-from-latest ${version} ${n} ==="
            just --justfile {{source_file()}} draft-dev-from-latest "${version}" "${n}"
            ;;

        rc)
            if [ -z "${version}" ]; then
                branch="$(git rev-parse --abbrev-ref HEAD)"
                if [[ "${branch}" =~ ^release/v([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
                    version="${BASH_REMATCH[1]}"
                    echo "Auto-detected version ${version} from branch ${branch}"
                else
                    echo "ERROR: No version provided and branch '${branch}' doesn't match release/vX.Y.Z"
                    echo "Usage: just release go rc <version> [n]"
                    exit 1
                fi
            fi

            if [ -z "${n}" ]; then
                existing="$(git tag -l "v${version}-rc.*" --sort=-v:refname | head -1 || true)"
                if [ -n "${existing}" ]; then
                    prev_n="${existing##*-rc.}"
                    n=$((prev_n + 1))
                else
                    n=1
                fi
                echo "Auto-detected festival RC N=${n}"
            fi

            echo "== RC Bundle Release: v${version}-rc.${n} =="
            echo "Using latest already-created RC tags from camp and fest."
            echo ""
            echo "=== Festival: draft-rc-from-latest ${version} ${n} ==="
            just --justfile {{source_file()}} draft-rc-from-latest "${version}" "${n}"
            ;;

        stable)
            if [ -z "${version}" ]; then
                latest_rc="$(git tag -l "v*-rc.*" --sort=-v:refname | head -1 || true)"
                if [ -n "${latest_rc}" ]; then
                    version="${latest_rc%-rc.*}"
                    version="${version#v}"
                    echo "Auto-detected version ${version} from festival RC ${latest_rc}"
                else
                    echo "ERROR: No version provided and no festival RC tags found."
                    echo "Usage: just release go stable <festival-version>"
                    exit 1
                fi
            fi

            echo "== Stable Bundle Release: v${version} =="
            echo "Using latest already-created stable tags from camp and fest."
            echo ""
            echo "=== Festival: draft-stable-from-latest ${version} ==="
            just --justfile {{source_file()}} draft-stable-from-latest "${version}"
            ;;
    esac

    echo ""
    echo "If camp/fest need new tags first, cut them in those repos before rerunning this command."

# Preview what a bundled festival release would do without executing it.
[no-cd]
go-dry-run channel version="" n="" level="":
    #!/usr/bin/env bash
    set -euo pipefail

    channel="{{channel}}"
    version="{{version}}"
    n="{{n}}"

    latest_tag_for_repo() {
        local repo="$1" mode="$2" pattern=""
        case "${mode}" in
            stable) pattern='^v[0-9]+(\.[0-9]+)*$' ;;
            rc)     pattern='^v[0-9]+(\.[0-9]+)*-rc\.[0-9]+$' ;;
            dev)    pattern='^v[0-9]+(\.[0-9]+)*-dev\.[0-9]+$' ;;
        esac
        git -C "${repo}" tag -l 'v*' --sort=-v:refname | grep -E "${pattern}" | head -1 || true
    }

    case "${channel}" in
        dev|rc|stable) ;;
        *) echo "ERROR: channel must be 'dev', 'rc', or 'stable'"; exit 1 ;;
    esac

    if [ -n "{{level}}" ]; then
        echo "ERROR: 'level' is not supported here."
        echo "Use repo-local camp/fest release commands to create their tags first."
        exit 1
    fi

    git fetch --tags >/dev/null 2>&1 || true
    git -C fest fetch --tags >/dev/null 2>&1 || true
    git -C camp fetch --tags >/dev/null 2>&1 || true

    fest_dev="$(latest_tag_for_repo fest dev)"
    camp_dev="$(latest_tag_for_repo camp dev)"
    fest_rc="$(latest_tag_for_repo fest rc)"
    camp_rc="$(latest_tag_for_repo camp rc)"
    fest_stable="$(latest_tag_for_repo fest stable)"
    camp_stable="$(latest_tag_for_repo camp stable)"

    echo ""
    echo "== DRY RUN: Festival Bundle Release =="
    echo "Channel:  ${channel}"
    echo ""
    echo "Current state:"
    echo "  festival branch: $(git rev-parse --abbrev-ref HEAD)"
    echo "  fest:  dev=${fest_dev:-none}  rc=${fest_rc:-none}  stable=${fest_stable:-none}"
    echo "  camp:  dev=${camp_dev:-none}  rc=${camp_rc:-none}  stable=${camp_stable:-none}"
    echo ""

    case "${channel}" in
        dev)
            if [ -z "${version}" ]; then
                echo "ERROR: festival dev release requires an explicit festival version."
                echo "Usage: just release go-dry-run dev <festival-version> [n]"
                exit 1
            fi
            if [ -z "${n}" ]; then
                existing="$(git tag -l "v${version}-dev.*" --sort=-v:refname | head -1 || true)"
                if [ -n "${existing}" ]; then
                    prev_n="${existing##*-dev.}"
                    n=$((prev_n + 1))
                else
                    n=1
                fi
            fi
            echo "Would run:"
            echo "  just release draft-dev-from-latest ${version} ${n}"
            ;;
        rc)
            if [ -z "${version}" ]; then
                branch="$(git rev-parse --abbrev-ref HEAD)"
                if [[ "${branch}" =~ ^release/v([0-9]+\.[0-9]+\.[0-9]+)$ ]]; then
                    version="${BASH_REMATCH[1]}"
                else
                    echo "ERROR: No version provided and branch doesn't match release/vX.Y.Z"
                    exit 1
                fi
            fi
            if [ -z "${n}" ]; then
                existing="$(git tag -l "v${version}-rc.*" --sort=-v:refname | head -1 || true)"
                if [ -n "${existing}" ]; then
                    prev_n="${existing##*-rc.}"
                    n=$((prev_n + 1))
                else
                    n=1
                fi
            fi
            echo "Would run:"
            echo "  just release draft-rc-from-latest ${version} ${n}"
            ;;
        stable)
            if [ -z "${version}" ]; then
                latest_rc="$(git tag -l "v*-rc.*" --sort=-v:refname | head -1 || true)"
                if [ -n "${latest_rc}" ]; then
                    version="${latest_rc%-rc.*}"
                    version="${version#v}"
                else
                    echo "ERROR: No version provided and no festival RC tags found"
                    exit 1
                fi
            fi
            echo "Would run:"
            echo "  just release draft-stable-from-latest ${version}"
            ;;
    esac

    echo ""
    echo "This command does not create camp/fest tags."
    echo "Cut those in their own repos first if newer tags are needed."

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

# Human-friendly aliases for the most common end-to-end release flows
[no-cd]
draft-stable-from-latest version:
    just --justfile {{source_file()}} draft-from-latest "{{version}}" stable

[no-cd]
draft-rc-from-latest version n="1":
    just --justfile {{source_file()}} draft-from-latest "{{version}}" rc "{{n}}"

[no-cd]
draft-dev-from-latest version n="1":
    just --justfile {{source_file()}} draft-from-latest "{{version}}" dev "{{n}}"

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
