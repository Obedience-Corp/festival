---
title: "obey session archive"
linkTitle: "obey session archive"
description: "Soft-hide one session from default lists"
---

## obey session archive

Soft-hide one session from default lists

### Synopsis

Archive exactly one session. Archiving is a soft hide only; it does not stop or delete the session.

```
obey session archive <session-selector> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for archive
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
