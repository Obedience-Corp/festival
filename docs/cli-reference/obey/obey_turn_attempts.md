---
title: "obey turn attempts"
linkTitle: "obey turn attempts"
description: "List immutable attempts for a durable turn"
---

## obey turn attempts

List immutable attempts for a durable turn

```
obey turn attempts <turn-id> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID
      --cursor string     resume from an opaque attempt cursor
      --diagnostics       include authorized provider execution identifiers
  -h, --help              help for attempts
      --json              output versioned stable JSON
      --limit uint32      maximum attempts to return
      --newest-first      show newest attempts first
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey turn](../obey_turn/)	 - Inspect and recover durable turns
