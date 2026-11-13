---
title: "camp project prune"
linkTitle: "camp project prune"
description: "Delete merged branches in a project"
---

## camp project prune

Delete merged branches in a project

### Synopsis

Delete local branches that have been merged into the default branch.

Auto-detects the current project from your working directory,
or accepts a project name as a positional argument.

Protected branches (default branch, current branch) are never deleted.

A merged branch's worktree is removed with it. When that worktree holds
uncommitted edits, they are saved first and the command prints how to restore
them; saved edits are dropped after 90 days. Files git ignores one by one, such
as .env.local, are saved with them. Folders ignored as a whole, such as
node_modules/ or a build folder, are deleted and not saved; the confirmation
and the result name them. The worktree is kept instead when it is locked, was
edited in the last 14 days, has a merge or rebase in progress, holds more than
50 MiB of uncommitted and ignored files, or has changes inside a submodule
that a save could not capture.

A branch whose upstream is gone is treated as merged when its commits match a
commit on the default branch, or when GitHub (through the gh CLI) reports a
merged pull request whose head is the branch's local tip.

Examples:
  camp project prune                     # Prune current project
  camp project prune camp                # Prune by name
  camp project prune -p camp             # Prune by flag
  camp project prune --dry-run           # Preview what would be deleted
	camp project prune --remote            # Also prune stale remote tracking refs
  camp project prune --remote-delete     # Also delete merged branches on origin
  camp project prune --keep-dirty        # Never remove a worktree with uncommitted edits
  camp project prune --saved             # List saved uncommitted edits
  camp project prune --restore my-branch # Recreate a removed worktree with its saved edits
  camp project prune --drop my-branch    # Delete saved edits now

```
camp project prune [project-name] [flags]
```

### Options

```
      --discard-dirty    Remove worktrees with uncommitted changes without saving them (unpushed submodule commits still keep a worktree)
      --drop string      Delete the saved edits for this branch
  -n, --dry-run          Preview without deleting
  -f, --force            Skip local branch deletion confirmation
  -h, --help             help for prune
      --keep-dirty       Keep every worktree that has uncommitted changes
  -p, --project string   Project name (auto-detected from cwd)
      --remote           Also prune stale remote tracking refs
      --remote-delete    Also delete merged branches on origin (destructive)
      --restore string   Recreate the removed worktree for this branch with its saved edits
      --saved            List uncommitted edits saved from removed worktrees
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
* [camp project prune all](../camp_project_prune_all/)	 - Delete merged branches across all projects
