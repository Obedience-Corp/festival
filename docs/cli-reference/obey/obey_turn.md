---
title: "obey turn"
linkTitle: "obey turn"
description: "Inspect and recover durable turns"
---

## obey turn

Inspect and recover durable turns

### Synopsis

Inspect durable turn state and make explicit, fenced recovery decisions.

### Options

```
  -h, --help   help for turn
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey turn attempts](../obey_turn_attempts/)	 - List immutable attempts for a durable turn
* [obey turn reconcile](../obey_turn_reconcile/)	 - Ask the adapter for authoritative recovery evidence
* [obey turn resolve](../obey_turn_resolve/)	 - Explicitly resolve a recovery-required turn
* [obey turn show](../obey_turn_show/)	 - Show one durable turn
* [obey turn transcript](../obey_turn_transcript/)	 - Show transcript entries belonging to a durable turn
