---
title: "fest reorder sequence"
linkTitle: "fest reorder sequence"
description: "Reorder sequences within a phase"
---

## fest reorder sequence

Reorder sequences within a phase

### Synopsis

Move a sequence from one position to another within a phase.

Elements between the source and destination positions are shifted accordingly.

If --phase is omitted and you're inside a phase directory, it will use the current phase.

```
fest reorder sequence <from> <to> [flags]
```

### Examples

```
  fest reorder sequence 3 1                            # Use current phase (if inside one)
  fest reorder sequence --phase 1 3 1                  # Numeric shortcut for phase 001_*
  fest reorder sequence --phase 001_PLAN 3 1           # Move sequence 03 to position 01
  fest reorder sequence --phase ./003_IMPLEMENT 1 4    # Move sequence 01 to position 04
```

### Options

```
  -h, --help           help for sequence
      --phase string   phase directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before reordering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --verbose         show detailed output
```

### SEE ALSO

* [fest reorder](../fest_reorder/)	 - Reorder festival elements
