---
title: "obey logs"
linkTitle: "obey logs"
description: "Tail daemon logs"
---

## obey logs

Tail daemon logs

### Synopsis

Display daemon log output. Uses follow mode by default.

```
obey logs [flags]
```

### Options

```
  -h, --help        help for logs
  -n, --lines int   number of lines to show (default 50)
      --no-follow   print logs and exit (don't follow)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
