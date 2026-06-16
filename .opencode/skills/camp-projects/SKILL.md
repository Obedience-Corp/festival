---
name: camp-projects
description: Manage campaign submodule projects. Use when committing inside `projects/*`, deciding status/pull/push scope (root vs submodule vs all), or creating/removing project worktrees.
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
