---
title: "fest task completed"
linkTitle: "fest task completed"
description: "Mark a task as complete"
---

## fest task completed

Mark a task as complete

### Synopsis

Mark a task as complete.

Quality gates are evaluated first and block completion on failure. By default a
confirmation prompt is shown; pass --yes to skip it for non-interactive or agent
use. --json emits a structured result and requires --yes.

```
fest task completed [task] [flags]
```

### Options

```
  -h, --help   help for completed
      --json   output as JSON (requires --yes)
  -y, --yes    skip the interactive confirmation prompt
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
