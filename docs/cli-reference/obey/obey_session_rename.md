---
title: "obey session rename"
linkTitle: "obey session rename"
description: "Change a session's display name"
---

## obey session rename

Change a session's display name

### Synopsis

Rename a session. The display name is the label clients show for the session.
The agent name, which obey uses for message routing, workload class, and
metering, does not change, and neither do status, history, or any running
process.

Live, ended, and external sessions can all be renamed. Surrounding whitespace
is trimmed. A name must be at most 120 characters and free of control
characters. An empty name clears the label, and clients show the agent name
again.

```
obey session rename <session-selector> <name> [flags]
```

### Examples

```
  # Give a session a name you will recognize later
  obey session rename 7fcde681 "release notes draft"

  # Clear the label
  obey session rename 7fcde681 ""
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for rename
      --json              output the result as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
