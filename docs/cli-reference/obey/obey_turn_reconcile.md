---
title: "obey turn reconcile"
linkTitle: "obey turn reconcile"
description: "Ask the adapter for authoritative recovery evidence"
---

## obey turn reconcile

Ask the adapter for authoritative recovery evidence

### Synopsis

Ask the adapter for authoritative evidence. Reconciliation does not guess that interrupted work is safe to replay.

```
obey turn reconcile <turn-id> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID
  -h, --help              help for reconcile
      --json              output versioned stable JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey turn](../obey_turn/)	 - Inspect and recover durable turns
