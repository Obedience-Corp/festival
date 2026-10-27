---
title: "obey delegation cancel"
linkTitle: "obey delegation cancel"
description: "cancel managed work through the owner daemon socket"
---

## obey delegation cancel

cancel managed work through the owner daemon socket

```
obey delegation cancel [flags]
```

### Options

```
      --campaign-id string         campaign owning the parent session
      --delegation-id string       durable managed delegation ID
  -h, --help                       help for cancel
      --json                       emit compact stable JSON for local clients
      --parent-session-id string   existing Obey-owned parent session
      --reason string              reason for requesting cancellation (default "operator request")
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey delegation](../obey_delegation/)	 - Manage delegation settings
