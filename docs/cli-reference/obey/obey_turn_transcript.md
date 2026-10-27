---
title: "obey turn transcript"
linkTitle: "obey turn transcript"
description: "Show transcript entries belonging to a durable turn"
---

## obey turn transcript

Show transcript entries belonging to a durable turn

```
obey turn transcript <turn-id> [flags]
```

### Options

```
      --attempt string    restrict transcript to one attempt ID
  -c, --campaign string   campaign name or UUID
      --cursor string     resume from an opaque transcript cursor
  -h, --help              help for transcript
      --json              output versioned stable JSON
      --limit uint32      maximum entries to return
      --newest-first      show newest entries first
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey turn](../obey_turn/)	 - Inspect and recover durable turns
