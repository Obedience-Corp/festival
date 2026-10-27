---
title: "obey status"
linkTitle: "obey status"
description: "Show daemon status"
---

## obey status

Show daemon status

### Synopsis

Resolve the daemon socket path from flags or config, then show a compact
daemon health summary.

```
obey status [flags]
```

### Options

```
  -h, --help   help for status
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
