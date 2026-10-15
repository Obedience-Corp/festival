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

By default, a person confirms a deferral by typing the task number in a
terminal. Pass --yes to defer non-interactively from an agent or app; the event
records automation as the actor. --json requires --yes. Agents should first
work ready tasks and record actual unblock attempts. Defer only a documented
external blocker when specific independent work can proceed; name that work
and why the blocker can wait in --reason. To resume this task instead, use
'fest task unblock --note "<what to try>"'.

```
fest task defer [task] [flags]
```

### Options

```
  -h, --help            help for defer
      --json            output as JSON (requires --yes)
      --reason string   why this blocker can wait until the end (required)
  -y, --yes             skip the interactive task-number confirmation
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
