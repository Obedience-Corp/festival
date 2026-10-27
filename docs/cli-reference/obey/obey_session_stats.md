---
title: "obey session stats"
linkTitle: "obey session stats"
description: "Show detailed per-session metrics"
---

## obey session stats

Show detailed per-session metrics

### Synopsis

Display token usage, turn count, latency, and duration for a session.

```
obey session stats <session-id> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for stats
      --json              output session stats as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
