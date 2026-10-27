---
title: "obey delegation start"
linkTitle: "obey delegation start"
description: "start managed work through the owner daemon socket"
---

## obey delegation start

start managed work through the owner daemon socket

```
obey delegation start [flags]
```

### Options

```
      --campaign-id string         campaign owning the parent session
  -h, --help                       help for start
      --idempotency-key string     stable request key; reuse when retrying an uncertain start
      --json                       emit compact stable JSON for local clients
      --parent-session-id string   existing Obey-owned parent session
      --profile string             configured managed-child profile
      --summary string             bounded non-authoritative context
      --task string                task for the managed child
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey delegation](../obey_delegation/)	 - Manage delegation settings
