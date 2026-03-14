---
title: "fest remove phase"
linkTitle: "fest remove phase"
description: "Remove a phase and renumber subsequent phases"
---

## fest remove phase

Remove a phase and renumber subsequent phases

### Synopsis

Remove a phase by number or path and automatically renumber all following phases.
		
Warning: This will permanently delete the phase and all its contents!

```
fest remove phase [phase-number|phase-path] [flags]
```

### Examples

```
  fest remove phase 2                    # Remove phase 002
  fest remove phase 002_DEFINE_INTERFACES # Remove by directory name
  fest remove phase ./002_DEFINE          # Remove by path
```

### Options

```
  -h, --help   help for phase
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
