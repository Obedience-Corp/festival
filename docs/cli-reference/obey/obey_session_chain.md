---
title: "obey session chain"
linkTitle: "obey session chain"
description: "Manage watch chains between sessions"
---

## obey session chain

Manage watch chains between sessions

### Synopsis

Create directional links between two agent sessions so that when
the source session produces a completion, its output is automatically
forwarded to the target session as input.

Two relay modes are available:

  grpc  - observes completions via the activity subscription and sends
          them directly (low latency, recommended).
  file  - writes completions to a relay file, detects changes with
          fsnotify, reads the file and forwards (debuggable, works
          across daemon instances).

Chains are managed by the daemon and survive CLI disconnection.
Use "obey session chain ls" and "obey session chain rm" to manage them.

### Options

```
  -h, --help   help for chain
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
* [obey session chain create](../obey_session_chain_create/)	 - Create a watch chain between two sessions
* [obey session chain list](../obey_session_chain_list/)	 - List active watch chains
* [obey session chain remove](../obey_session_chain_remove/)	 - Remove a watch chain
