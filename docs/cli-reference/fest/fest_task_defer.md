---
title: "fest task defer"
linkTitle: "fest task defer"
description: "Defer a blocked task's blocker so the festival can keep moving"
---

## fest task defer

Defer a blocked task's blocker so the festival can keep moving

### Synopsis

Defer a blocker you cannot clear right now.

The task stays blocked and still renders as blocked everywhere. Its dependents
become ready, so the rest of the festival proceeds. When everything else is
settled, fest next brings the deferred tasks back for another attempt, and the
festival cannot be promoted to completed while any blocker is deferred unless
you pass --force.

This verb has no --yes and no --json. Deferring is an operator decision and
there is deliberately no way to script it. If you want to send the task back to
the executor instead, use 'fest task unblock --note "<what to try>"'.

```
fest task defer [task] [flags]
```

### Options

```
  -h, --help            help for defer
      --reason string   why this blocker can wait until the end (required)
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
