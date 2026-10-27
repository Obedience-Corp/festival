---
title: "obey session turns"
linkTitle: "obey session turns"
description: "List durable turns for a session"
---

## obey session turns

List durable turns for a session

```
obey session turns <session-selector> [flags]
```

### Examples

```
  obey session turns @builder
  obey session turns id:SESSION --recovery-required --json
```

### Options

```
  -c, --campaign string     campaign name or UUID
      --cursor string       resume from an opaque turn cursor
  -h, --help                help for turns
      --json                output versioned stable JSON
      --limit uint32        maximum turns to return
      --newest-first        show newest turns first
      --recovery-required   show only recovery-required turns
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
