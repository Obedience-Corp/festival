---
title: "obey session reopen"
linkTitle: "obey session reopen"
description: "Let one dismissed session draw attention again"
---

## obey session reopen

Let one dismissed session draw attention again

### Synopsis

Reopen exactly one session.

This clears dismissal only. Status, archive, and disposition stay as they were,
and the session's current attention signal is visible again.

```
obey session reopen <session-selector> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for reopen
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
