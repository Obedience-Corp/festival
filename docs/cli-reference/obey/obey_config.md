---
title: "obey config"
linkTitle: "obey config"
description: "Inspect daemon configuration"
---

## obey config

Inspect daemon configuration

### Synopsis

Report how the daemon's effective settings were arrived at.

This is read-only. It never writes configuration.

### Options

```
  -h, --help   help for config
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey config explain](../obey_config_explain/)	 - Show each effective setting and the layer that supplied it
