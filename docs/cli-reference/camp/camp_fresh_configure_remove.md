---
title: "camp fresh configure remove"
linkTitle: "camp fresh configure remove"
description: "Remove a follow-up command workflow step"
---

## camp fresh configure remove

Remove a follow-up command workflow step

```
camp fresh configure remove <name> [flags]
```

### Options

```
  -h, --help             help for remove
      --project string   Scope removal to a single project (default: global)
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
