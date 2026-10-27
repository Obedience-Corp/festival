---
title: "obey delegation capabilities"
linkTitle: "obey delegation capabilities"
description: "capabilities managed work through the owner daemon socket"
---

## obey delegation capabilities

capabilities managed work through the owner daemon socket

```
obey delegation capabilities [flags]
```

### Options

```
      --campaign-id string         campaign owning the parent session
  -h, --help                       help for capabilities
      --json                       emit compact stable JSON for local clients
      --parent-session-id string   existing Obey-owned parent session
      --profile string             configured managed-child profile to probe
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey delegation](../obey_delegation/)	 - Manage delegation settings
