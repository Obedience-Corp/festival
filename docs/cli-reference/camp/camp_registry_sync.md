---
title: "camp registry sync"
linkTitle: "camp registry sync"
description: "Sync current camp with registry"
---

## camp registry sync

Sync current camp with registry

### Synopsis

Update the registry entry for the current camp.

Run this after moving a camp directory to update its path
in the registry. Reads the camp ID from .campaign/campaign.yaml
and updates (or adds) the registry entry.

Examples:
  camp registry sync   # Run from inside a camp

```
camp registry sync [flags]
```

### Options

```
  -h, --help   help for sync
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp registry](../camp_registry/)	 - Manage the camp registry
