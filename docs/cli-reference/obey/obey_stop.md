---
title: "obey stop"
linkTitle: "obey stop"
description: "Stop the daemon"
---

## obey stop

Stop the daemon

### Synopsis

Gracefully stop the running daemon. Exits 0 when no daemon is running.

```
obey stop [flags]
```

### Options

```
  -d, --data-dir string   data directory of the daemon to stop (overrides config)
  -h, --help              help for stop
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
