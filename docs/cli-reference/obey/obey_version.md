---
title: "obey version"
linkTitle: "obey version"
description: "Show version information"
---

## obey version

Show version information

### Synopsis

Show obey version, build information, and runtime details.

When both --short and --json are provided, --json wins.

Examples:
  obey version           Show full version info
  obey version --short   Show only version number
  obey version --json    Output as JSON

```
obey version [flags]
```

### Options

```
  -h, --help    help for version
      --json    emit the version report as JSON
      --short   print only the version number
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
