---
title: "obey session attach"
linkTitle: "obey session attach"
description: "Attach to a live session stream"
---

## obey session attach

Attach to a live session stream

### Synopsis

Attach to a live session with transcript backfill, a high-water marker, and live activity.

```
obey session attach [session-selector] [flags]
```

### Examples

```
  obey session attach session-123
  obey session attach @builder --from-seq 20
  obey session attach session-123 --no-backfill --json
```

### Options

```
      --backfill-limit uint32   maximum transcript rows to backfill (daemon default when 0)
  -c, --campaign string         campaign name or UUID (defaults to the campaign at the current working directory)
      --from-seq uint           only backfill transcript entries after this sequence
  -h, --help                    help for attach
      --json                    output attach stream as newline-delimited JSON
      --no-backfill             skip transcript backfill and attach to live activity
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
