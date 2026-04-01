---
title: "camp shortcuts reset"
linkTitle: "camp shortcuts reset"
description: "Reset auto-generated shortcuts to current defaults"
---

## camp shortcuts reset

Reset auto-generated shortcuts to current defaults

### Synopsis

Reset shortcuts to match current defaults while preserving user-defined shortcuts.

Default behavior:
  - Adds missing default shortcuts
  - Removes stale auto-generated shortcuts (no longer in defaults)
  - Updates modified auto-generated shortcuts to match defaults
  - Preserves all user-defined shortcuts

With --all:
  - Replaces entire shortcuts config with defaults
  - Removes all user-defined shortcuts (with confirmation)

With --dry-run:
  - Shows what would change without saving

```
camp shortcuts reset [flags]
```

### Examples

```
  camp shortcuts reset             # Reset auto shortcuts, preserve custom
  camp shortcuts reset --dry-run   # Preview changes
  camp shortcuts reset --all       # Full reset (drops custom shortcuts)
```

### Options

```
      --all       Reset all shortcuts including user-defined ones
      --dry-run   Show what would change without saving
  -h, --help      help for reset
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp shortcuts](../camp_shortcuts/)	 - List all available shortcuts
