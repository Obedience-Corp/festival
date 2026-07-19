---
title: "camp fresh configure move"
linkTitle: "camp fresh configure move"
description: "Move a follow-up command workflow step"
---

## camp fresh configure move

Move a follow-up command workflow step

```
camp fresh configure move <name> [flags]
```

### Options

```
      --down             Move the step later in the workflow
  -h, --help             help for move
      --project string   Scope the move to a single project (default: global)
      --up               Move the step earlier in the workflow
```

### Options inherited from parent commands

```
  -b, --branch string   Branch to create after syncing (overrides config)
  -n, --dry-run         Preview without making changes
      --no-branch       Skip branch creation even if configured
      --no-color        disable colored output
      --no-follow-up    Skip configured follow-up command workflows
      --no-prune        Skip pruning merged branches
      --no-push         Skip pushing the new branch upstream
```

### SEE ALSO

* [camp fresh configure](../camp_fresh_configure/)	 - Configure the camp fresh workflow
