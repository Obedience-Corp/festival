---
name: camp-projects
description: Manage campaign submodule projects. Use when committing inside `projects/*`, deciding status/pull/push scope (root vs submodule vs all), or creating/removing project worktrees.
version: "1.3.0"
author: Obedience Corp
license: MIT
metadata:
  hermes:
    tags:
      - camp
      - projects
      - submodules
      - worktrees
      - git
    category: camp
---

# Campaign Projects

## Commit in Submodules

```bash
camp p commit -m "fix: message"
```

Pointer sync is intentional and root-level:

```bash
camp refs-sync
camp refs-sync projects/camp
```

## Scope-Safe Status / Sync

```bash
camp status
camp status --sub
camp status all

camp pull --sub
camp push --sub
```

Use `all` commands only when broad workspace churn is intended.

## Rename a Project

```bash
camp project rename <current> <new>
camp project rename <current> <new> --dry-run --json
camp project rename <current> <new> --remote-url git@github.com:org/new-name.git
```

Renames submodules, linked workspace symlinks, and campaign-owned directories,
migrating the campaign references in one transaction. Dirty checkouts and linked
worktrees are preserved; destination collisions and unmanaged directories are
rejected before anything is written.

Camp never guesses that the upstream repository was renamed too. Pass
`--remote-url` to move origin as part of the same transaction.

## Worktrees

```bash
camp project worktree add <name>
camp project worktree list
camp project worktree remove <name>
```

## Common Mistakes

- Assuming submodule commits should auto-update campaign-root pointers.
- Running `camp pull`/`camp push` expecting submodule scope without `--sub`.
- Passing worktree path to remove; command expects worktree name.
- Renaming a project directory by hand instead of `camp project rename`, which
  leaves the campaign references pointing at the old name.
