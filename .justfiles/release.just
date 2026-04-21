# Release management
# Three channels:
# - dev: moving prerelease from develop
# - rc: release candidate prerelease
# - stable: public release

[private]
[no-cd]
default:
    @go -C tools/release-operator run . help

# Pin submodules to latest stable tags without creating a festival release
[no-cd]
refresh-stable:
    go -C tools/release-operator run . pin --repo-root ../.. --mode stable

# Pin submodules to latest rc tags without creating a festival release
[no-cd]
refresh-rc:
    go -C tools/release-operator run . pin --repo-root ../.. --mode rc

# Pin submodules to latest dev/prerelease tags without creating a festival release
[no-cd]
refresh-dev:
    go -C tools/release-operator run . pin --repo-root ../.. --mode dev

[private]
[no-cd]
require-stable-publish-credentials:
    go -C tools/release-operator run . require-stable-publish-credentials --repo-root ../..

# Show operator-facing release readiness for current branch and latest tags
[no-cd]
status:
    go -C tools/release-operator run . status --repo-root ../..

# Pre-release checks: show submodule versions, dirty state, and build validation
[no-cd]
preflight mode="stable":
    go -C tools/release-operator run . preflight --repo-root ../.. --mode "{{mode}}"

# Preview the next bundled release without mutating submodule refs, docs, or tags.
[no-cd]
plan mode="stable" fest="latest" camp="latest":
    go -C tools/release-operator run . plan --repo-root ../.. --mode "{{mode}}" --fest-tag "{{fest}}" --camp-tag "{{camp}}"

# One-command bundled release from already-created camp/fest tags.
# Selectors:
# - latest: use the newest tag for the requested release channel
# - keep: keep the currently pinned exact tag for that submodule
# - vX.Y.Z: pin a specific release tag
[no-cd]
[confirm("This will create a dev festival release from the latest dev tags in camp and fest. Continue?")]
dev fest="latest" camp="latest":
    just test release-operator
    go -C tools/release-operator run . bundle --repo-root ../.. --fest-tag "{{fest}}" --camp-tag "{{camp}}" dev

[no-cd]
[confirm("This will create an RC festival release from the latest rc tags in camp and fest. Continue?")]
rc fest="latest" camp="latest":
    just test release-operator
    go -C tools/release-operator run . bundle --repo-root ../.. --fest-tag "{{fest}}" --camp-tag "{{camp}}" rc

[no-cd]
[confirm("This will create a stable festival release from selected stable camp/fest tags on main. Continue?")]
stable fest="latest" camp="latest":
    just test release-operator
    go -C tools/release-operator run . bundle --repo-root ../.. --fest-tag "{{fest}}" --camp-tag "{{camp}}" stable

# Run GoReleaser dry run (no publish)
[no-cd]
dry-run:
    goreleaser release --snapshot --clean --skip=publish,announce

# First stable release bootstrap:
# - create/push fest + camp stable tags at their current HEAD
# - pin festival submodules to those tags
# - commit/push submodule pointer update
# - create/push festival stable tag
[private]
[no-cd]
[confirm("This will create and push fest/camp tags, then create and push a STABLE festival release tag. Continue?")]
draft-bootstrap version fest_version camp_version:
    go -C tools/release-operator run . draft-bootstrap --repo-root ../.. --version "{{version}}" --fest-version "{{fest_version}}" --camp-version "{{camp_version}}"

# Unified release automation from latest submodule tags:
# - mode=stable: latest stable tags (vX.Y.Z)
# - mode=rc: latest rc tags (vX.Y.Z-rc.N)
# - mode=dev: latest dev tags (vX.Y.Z-dev.N)
# - pin submodules, refresh docs, commit/push pointer update if needed
# - create/push festival release tag for the selected channel
[private]
[no-cd]
draft-from-latest version mode="stable" n="1":
    go -C tools/release-operator run . draft-from-latest --repo-root ../.. --version "{{version}}" --mode "{{mode}}" --n "{{n}}"

# Human-friendly aliases for the most common end-to-end release flows
[private]
[no-cd]
draft-stable-from-latest version:
    just --justfile {{source_file()}} draft-from-latest "{{version}}" stable

[private]
[no-cd]
draft-rc-from-latest version n="1":
    just --justfile {{source_file()}} draft-from-latest "{{version}}" rc "{{n}}"

[private]
[no-cd]
draft-dev-from-latest version n="1":
    just --justfile {{source_file()}} draft-from-latest "{{version}}" dev "{{n}}"

# Draft a stable release: preflight + tag + push (triggers CI)
[private]
[no-cd]
[confirm("This will create and push a STABLE release tag. Continue?")]
draft version:
    go -C tools/release-operator run . draft --repo-root ../.. --version "{{version}}"

# Draft an RC release: preflight + rc tag + push (triggers CI, marked as prerelease)
[private]
[no-cd]
[confirm("This will create and push an RC release tag. Continue?")]
draft-rc version n="1":
    go -C tools/release-operator run . draft-rc --repo-root ../.. --version "{{version}}" --n "{{n}}"

# Draft a dev release: preflight + dev tag + push (triggers CI, marked as prerelease)
[private]
[no-cd]
[confirm("This will create and push a DEV release tag. Continue?")]
draft-dev version n="1":
    go -C tools/release-operator run . draft-dev --repo-root ../.. --version "{{version}}" --n "{{n}}"

# Clean up a release (delete tag + GitHub release)
[no-cd]
[confirm("This will delete the GitHub release and tag. Continue?")]
cleanup tag:
    go -C tools/release-operator run . cleanup --repo-root ../.. --tag "{{tag}}"

# Full release (CI should handle this, but for manual use)
[no-cd]
publish:
    goreleaser release --clean
