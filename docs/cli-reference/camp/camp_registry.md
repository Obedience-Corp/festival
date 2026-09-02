---
title: "camp registry"
linkTitle: "camp registry"
description: "Manage the camp registry"
---

## camp registry

Manage the camp registry

### Synopsis

Manage the camp registry at ~/.obey/campaign/registry.json.

The registry tracks all known camps for quick navigation and lookup.
Use these commands to maintain registry health and resolve issues.

Commands:
  prune   Remove stale entries (camps that no longer exist)
  sync    Update registry entry for current camp
  check   Validate registry integrity

```
camp registry [flags]
```

### Examples

```
  camp registry prune             Remove entries for non-existent camps
  camp registry prune --dry-run   Show what would be removed
  camp registry sync              Update path for current camp
  camp registry check             Check for issues
```

### Options

```
  -h, --help   help for registry
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp registry check](../camp_registry_check/)	 - Check registry integrity
* [camp registry prune](../camp_registry_prune/)	 - Remove stale registry entries
* [camp registry sync](../camp_registry_sync/)	 - Sync current camp with registry
