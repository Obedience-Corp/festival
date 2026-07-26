---
title: "fest task update"
linkTitle: "fest task update"
description: "Update a task's progress percentage"
---

## fest task update

Update a task's progress percentage

### Synopsis

Update a task's progress percentage (0-100).

This is a frictionless forward-motion signal and does not prompt for
confirmation. Progress must stay below 100%; use 'fest task completed' at
100% so quality gates are evaluated. When [task] is omitted the current task
is auto-detected.

```
fest task update [task] <percent> [flags]
```

### Options

```
  -h, --help   help for update
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest task](../fest_task/)	 - Manage task status (show, edit, complete, block, reset)
