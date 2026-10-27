---
title: "obey session dismiss"
linkTitle: "obey session dismiss"
description: "Stop one session from drawing attention"
---

## obey session dismiss

Stop one session from drawing attention

### Synopsis

Dismiss exactly one session from operator attention.

The session stays readable and keeps running. Dismissal does not stop,
archive, or delete it, and it does not change disposition. A repeat dismiss
keeps the original time. Bring it back with "obey session reopen".

```
obey session dismiss <session-selector> [flags]
```

### Examples

```
  obey session dismiss 7fcde681
  obey session reopen 7fcde681
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for dismiss
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
