---
title: "fest reorder phase"
linkTitle: "fest reorder phase"
description: "Reorder phases in a festival"
---

## fest reorder phase

Reorder phases in a festival

### Synopsis

Move a phase from one position to another within a festival.

Elements between the source and destination positions are shifted accordingly.
For example, moving phase 3 to position 1 will shift phases 1 and 2 down.

```
fest reorder phase <from> <to> [festival-dir] [flags]
```

### Examples

```
  fest reorder phase 3 1                    # Move phase 003 to position 001 (dry-run preview)
  fest reorder phase 1 3 ./my-festival      # Move phase 001 to position 003
  fest reorder phase 4 2 --skip-dry-run     # Apply immediately without preview
```

### Options

```
  -h, --help   help for phase
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
