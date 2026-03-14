---
title: "fest reorder task"
linkTitle: "fest reorder task"
description: "Reorder tasks within a sequence"
---

## fest reorder task

Reorder tasks within a sequence

### Synopsis

Move a task from one position to another within a sequence.

Elements between the source and destination positions are shifted accordingly.
Parallel tasks (multiple tasks with the same number) are moved together.

If --sequence is omitted and you're inside a sequence directory, it will use the current sequence.

```
fest reorder task <from> <to> [flags]
```

### Examples

```
  fest reorder task 3 1                               # Use current sequence (if inside one)
  fest reorder task --sequence 1 3 1                  # Numeric shortcut for sequence 01_*
  fest reorder task --phase 1 --sequence 2 3 1        # Phase 001_*, sequence 02_*
  fest reorder task --sequence ./path/to/sequence 1 5
```

### Options

```
  -h, --help              help for task
      --phase string      phase directory (numeric shortcut, name, or path)
      --sequence string   sequence directory (numeric shortcut, name, or path)
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
