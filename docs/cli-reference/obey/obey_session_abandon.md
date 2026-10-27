---
title: "obey session abandon"
linkTitle: "obey session abandon"
description: "Mark an unaccounted-for session abandoned"
---

## obey session abandon

Mark an unaccounted-for session abandoned

### Synopsis

Terminalize exactly one session that Obey no longer holds. This does not stop a process Obey is running; use `session stop` for that case. The default reason is recorded when --reason is omitted.

```
obey session abandon <session-selector> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for abandon
      --json              output the result as JSON
      --reason string     operator reason (defaults to abandoned)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
