---
title: "fest task blocked"
linkTitle: "fest task blocked"
description: "Mark a task as blocked"
---

## fest task blocked

Mark a task as blocked

### Synopsis

Mark a task as blocked, pausing work and notifying the user.

By default a confirmation prompt is shown; pass --yes to skip it for
non-interactive or agent use. --json emits a structured result and requires
--yes.

```
fest task blocked [task] [flags]
```

### Options

```
  -h, --help            help for blocked
      --json            output as JSON (requires --yes)
      --reason string   reason for the blocker (required)
  -y, --yes             skip the interactive confirmation prompt
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
