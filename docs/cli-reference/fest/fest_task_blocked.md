---
title: "fest task blocked"
linkTitle: "fest task blocked"
description: "Mark a task as blocked"
---

## fest task blocked

Mark a task as blocked

### Synopsis

Mark a task as blocked, pausing work and notifying the user.

Repeat --tried for each unblock attempt that failed. The operator sees these
when deciding whether to defer the blocker, and a block with no recorded
attempts is likely to be sent back.

By default a confirmation prompt is shown; pass --yes to skip it for
non-interactive or agent use. --json emits a structured result and requires
--yes.

--list reports the festival's blockers instead of reporting one. It takes no
task and no --reason, writes nothing, and never prompts. Open blockers are
listed before deferred ones; --open and --deferred narrow the list to one of
them.

```
fest task blocked [task] [flags]
```

### Options

```
      --deferred            with --list, show only deferred blockers
  -h, --help                help for blocked
      --json                output as JSON (requires --yes)
      --list                list the festival's blockers instead of reporting one
      --open                with --list, show only blockers no operator has deferred
      --reason string       reason for the blocker (required)
      --tried stringArray   an unblock attempt that failed; repeat for each attempt
  -y, --yes                 skip the interactive confirmation prompt
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
