---
title: "obey session unarchive"
linkTitle: "obey session unarchive"
description: "Show one archived session in default lists"
---

## obey session unarchive

Show one archived session in default lists

### Synopsis

Unarchive exactly one session. This only clears the soft-hide flag.

```
obey session unarchive <session-selector> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the current working directory)
  -h, --help              help for unarchive
      --json              output the result as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
