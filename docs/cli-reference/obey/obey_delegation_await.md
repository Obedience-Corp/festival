---
title: "obey delegation await"
linkTitle: "obey delegation await"
description: "await managed work through the owner daemon socket"
---

## obey delegation await

await managed work through the owner daemon socket

```
obey delegation await [flags]
```

### Options

```
      --campaign-id string         campaign owning the parent session
      --delegation-id string       durable managed delegation ID
  -h, --help                       help for await
      --json                       emit compact stable JSON for local clients
      --parent-session-id string   existing Obey-owned parent session
      --timeout duration           wait up to 30s; 0s polls, timeout never cancels work (default 30s)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey delegation](../obey_delegation/)	 - Manage delegation settings
