---
title: "fest remove sequence"
linkTitle: "fest remove sequence"
description: "Remove a sequence and renumber subsequent sequences"
---

## fest remove sequence

Remove a sequence and renumber subsequent sequences

### Synopsis

Remove a sequence by number or name and automatically renumber all following sequences.

Warning: This will permanently delete the sequence and all its contents!

If --phase is omitted and you're inside a phase directory, it will use the current phase.

```
fest remove sequence [sequence-number|sequence-name] [flags]
```

### Examples

```
  fest remove sequence 2                   # Use current phase (if inside one)
  fest remove sequence --phase 1 2          # Numeric shortcut for phase 001_*
  fest remove sequence --phase 001_PLAN 2   # Remove sequence 02
  fest remove sequence --phase 001_PLAN 02_architecture
```

### Options

```
  -h, --help           help for sequence
      --phase string   phase directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before removal
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --verbose         show detailed output
```

### SEE ALSO

* [fest remove](../fest_remove/)	 - Remove festival elements and renumber
