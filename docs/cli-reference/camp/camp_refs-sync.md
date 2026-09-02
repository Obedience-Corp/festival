---
title: "camp refs-sync"
linkTitle: "camp refs-sync"
description: "Sync submodule ref pointers in camp root"
---

## camp refs-sync

Sync submodule ref pointers in camp root

### Synopsis

Update the camp root's recorded submodule pointers to match
each submodule's current HEAD. Creates a single atomic commit.

Without arguments, syncs all submodules. Specify paths to sync specific ones.

Examples:
  camp refs-sync                      # Sync all dirty refs
  camp refs-sync projects/camp        # Sync specific submodule
  camp refs-sync --dry-run            # Show plan without executing

```
camp refs-sync [submodule...] [flags]
```

### Options

```
  -n, --dry-run   Show plan without executing
  -f, --force     Skip safety checks (staged changes)
  -h, --help      help for refs-sync
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
