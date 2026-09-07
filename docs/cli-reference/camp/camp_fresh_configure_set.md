---
title: "camp fresh configure set"
linkTitle: "camp fresh configure set"
description: "Set a camp fresh workflow setting"
---

## camp fresh configure set

Set a camp fresh workflow setting

### Synopsis

Change a fresh.yaml settings key without opening the interactive TUI.

Keys:
  branch          working branch created after sync
  push_upstream   push the working branch with --set-upstream
  prune           prune merged branches (camp-wide)
  prune_remote    prune stale remote tracking refs (camp-wide)

Actions:
  inherit     clear the key (project inherits global; global restores the built-in)
  on / off    write an explicit bool
  no-branch   stay on the default branch
  branch      create a working branch; requires --value

prune and prune_remote are camp-wide. Pass them without --project.

Examples:
  camp fresh configure set prune --action off
  camp fresh configure set branch --action branch --value feat/next --project camp
  camp fresh configure set push_upstream --action inherit --project camp
  camp fresh configure set branch --action no-branch

```
camp fresh configure set <key> [flags]
```

### Options

```
      --action string    inherit, on, off, no-branch, or branch (required)
  -h, --help             help for set
      --json             emit a structured JSON result
      --project string   Project scope (default: global)
      --value string     Branch name when --action branch
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
