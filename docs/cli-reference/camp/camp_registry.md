---
title: "camp registry"
linkTitle: "camp registry"
description: "Manage the campaign registry"
---

## camp registry

Manage the campaign registry

### Synopsis

Manage the campaign registry at ~/.obey/campaign/registry.json.

The registry tracks all known campaigns for quick navigation and lookup.
Use these commands to maintain registry health and resolve issues.

Commands:
  prune   Remove stale entries (campaigns that no longer exist)
  sync    Update registry entry for current campaign
  check   Validate registry integrity

Examples:
  camp registry prune             Remove entries for non-existent campaigns
  camp registry prune --dry-run   Show what would be removed
  camp registry sync              Update path for current campaign
  camp registry check             Check for issues

```
camp registry [flags]
```

### Options

```
  -h, --help   help for registry
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp registry check](../camp_registry_check/)	 - Check registry integrity
* [camp registry prune](../camp_registry_prune/)	 - Remove stale registry entries
* [camp registry sync](../camp_registry_sync/)	 - Sync current campaign with registry
