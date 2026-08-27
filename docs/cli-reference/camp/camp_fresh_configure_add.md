---
title: "camp fresh configure add"
linkTitle: "camp fresh configure add"
description: "Add a follow-up command workflow step"
---

## camp fresh configure add

Add a follow-up command workflow step

```
camp fresh configure add <name> [flags]
```

### Options

```
      --continue-on-error   Keep running later follow-ups if this step fails
      --dir string          Directory relative to the project root to run the command in
  -h, --help                help for add
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
