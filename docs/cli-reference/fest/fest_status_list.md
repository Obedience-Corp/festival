---
title: "fest status list"
linkTitle: "fest status list"
description: "List entities by status"
---

## fest status list

List entities by status

### Synopsis

List festivals, phases, sequences, or tasks filtered by status.

Without filters, lists all festivals grouped by status.

```
fest status list [flags]
```

### Examples

```
  fest status list                     # List all festivals by status
  fest status list --status active     # List active festivals only
  fest status list --type task --status pending  # List pending tasks
```

### Options

```
  -h, --help            help for list
      --json            output in JSON format
      --status string   filter by status
      --type string     entity type (festival, phase, sequence, task) (default "festival")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest status](../fest_status/)	 - Manage and query festival entity statuses
