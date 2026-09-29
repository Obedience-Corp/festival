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

Pass --note to tell the executor what to try. The note is stored on the task and
rendered under it by the next fest next, so the executor sees it even if it is
not running right now.

```
fest task unblock [task] [flags]
```

### Options

```
  -h, --help          help for unblock
      --json          output as JSON
      --note string   feedback for the executor, shown under the task on the next fest next
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
