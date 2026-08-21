#!/usr/bin/env bash
# Shared submodule guard for the release scripts. Source it; do not execute it.

# An uninitialized submodule is an empty directory, and `git -C <empty-dir>`
# walks up to the superproject rather than failing. Every query then answers for
# the festival repo instead of the tool, so `describe` returns the festival tag
# and `rev-parse HEAD` the festival commit. On a plain clone without
# `--recurse-submodules` that silently stamped both camp and fest with the
# festival version, and let the release pin check verify the festival tag
# against itself. Requiring a .git entry AND that git resolves the directory
# itself as the work tree root closes both holes.
require_initialized_submodule() {
    local repo_root="$1"
    local dir="$2"
    local path="$repo_root/$dir"
    local toplevel=""

    if [ ! -d "$path" ]; then
        echo "ERROR: submodule directory is missing: $dir (run: git submodule update --init --recursive)" >&2
        return 1
    fi

    if [ ! -e "$path/.git" ]; then
        echo "ERROR: submodule is not checked out: $dir (run: git submodule update --init --recursive)" >&2
        return 1
    fi

    toplevel="$(git -C "$path" rev-parse --show-toplevel 2>/dev/null || true)"
    if [ "$toplevel" != "$(cd "$path" && pwd -P)" ]; then
        echo "ERROR: $dir resolves to the superproject, not its own checkout (run: git submodule update --init --recursive)" >&2
        return 1
    fi
}
