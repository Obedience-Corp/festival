---
title: "camp fresh configure edit"
linkTitle: "camp fresh configure edit"
description: "Edit a follow-up command workflow step"
---

## camp fresh configure edit

Edit a follow-up command workflow step

### Synopsis

Update a follow-up in place, keeping its position in the sequence.

On a project that still inherits the global list, editing forks that list
into a project override the same way the interactive setup does.

Pass --name to rename the step. --run is required so the command being
saved is explicit rather than inferred from a previous value.

```
camp fresh configure edit <name> [flags]
```

### Options

```
      --continue-on-error   Keep running later follow-ups if this step fails
      --dir string          Directory relative to the project root to run the command in
  -h, --help                help for edit
      --name string         Rename the follow-up
      --project string      Scope this follow-up to a single project (default: global)
      --run string          Command to run for this follow-up step (required)
```

### Options inherited from parent commands

```
      --allow-default-target   Permit --cleanup-stack against the default branch (main/master). Without this, cleanup-stack refuses default-branch targets because every merged feature worktree would look like a stack child
  -b, --branch string          Branch to create after syncing (overrides config)
      --cleanup-stack          Target an existing aggregate branch and remove child worktrees merged into it by ancestry or squash (requires --branch; refuses the default branch unless --allow-default-target)
  -n, --dry-run                Preview without making changes
      --no-branch              Skip branch creation even if configured
      --no-color               disable colored output
      --no-follow-up           Skip configured follow-up command workflows
      --no-prune               Skip pruning merged branches
      --no-push                Skip pushing the new branch upstream
```

### SEE ALSO

* [camp fresh configure](../camp_fresh_configure/)	 - Configure the camp fresh workflow
