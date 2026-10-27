---
title: "obey session compact"
linkTitle: "obey session compact"
description: "Ask a session to compact its in-flight context"
---

## obey session compact

Ask a session to compact its in-flight context

### Synopsis

Request compaction of a session's context.

This sets a flag the session's RUNNING turn consumes at its next tool round. It
does not compact anything by itself, and this command does not claim otherwise.

Compaction targets the in-flight payload of an active turn, so a session with
nothing running is refused rather than queued: there is no payload to shrink
yet, and pretending the request was banked would be a promise the daemon has not
made.

Not every provider can compact. Where one cannot, the daemon refuses with the
reason rather than accepting a request it will never act on.

```
obey session compact [session-selector] [flags]
```

### Examples

```
  # Compact the current session
  obey session compact

  # Compact a specific one
  obey session compact 7fcde681
```

### Options

```
  -c, --campaign string   campaign name or UUID
  -h, --help              help for compact
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
