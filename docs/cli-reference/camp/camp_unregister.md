---
title: "camp unregister"
linkTitle: "camp unregister"
description: "Remove a camp from the registry"
---

## camp unregister

Remove a camp from the registry

### Synopsis

Remove a camp from the global registry.

This does NOT delete any files - it only removes the camp from
tracking in the global registry. Use this when:
  - A camp directory was deleted manually
  - A camp was moved to a different location
  - You no longer want to track a camp

The camp files remain untouched on disk.

You can specify the camp by name or ID (or ID prefix).

Examples:
  camp unregister old-project            # Remove by name
  camp unregister 550e84                 # Remove by ID prefix
  camp unregister old-project --force    # Remove without confirmation

```
camp unregister <name-or-id> [flags]
```

### Options

```
  -f, --force   Skip confirmation prompt
  -h, --help    help for unregister
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
