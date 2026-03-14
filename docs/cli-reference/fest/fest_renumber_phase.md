---
title: "fest renumber phase"
linkTitle: "fest renumber phase"
description: "Renumber phases in a festival"
---

## fest renumber phase

Renumber phases in a festival

### Synopsis

Renumber all phases starting from the specified number (default: 1).
		
Phases are numbered with 3 digits (001, 002, 003, etc.).

```
fest renumber phase [festival-dir] [flags]
```

### Examples

```
  fest renumber phase                    # Renumber phases in current directory (dry-run preview)
  fest renumber phase ./my-festival      # Renumber phases in specified directory
  fest renumber phase --start 2          # Start numbering from 002
  fest renumber phase --skip-dry-run     # Skip preview and apply changes immediately
```

### Options

```
  -h, --help   help for phase
```

### Options inherited from parent commands

```
      --backup          create backup before renumbering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --start int       starting number for renumbering (default 1)
      --verbose         show detailed output
```

### SEE ALSO

* [fest renumber](../fest_renumber/)	 - Renumber festival elements
