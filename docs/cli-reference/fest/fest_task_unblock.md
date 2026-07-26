---
title: "fest task unblock"
linkTitle: "fest task unblock"
description: "Clear a task's blocker and resume work"
---

## fest task unblock

Clear a task's blocker and resume work

### Synopsis

Clear a task's blocker, returning it to in_progress.

This is a frictionless forward-motion signal and does not prompt for
confirmation. When [task] is omitted the current task is auto-detected.

```
fest task unblock [task] [flags]
```

### Options

```
  -h, --help   help for unblock
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
