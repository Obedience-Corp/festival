---
title: "obey session modes"
linkTitle: "obey session modes"
description: "List execution modes for sessions"
---

## obey session modes

List execution modes for sessions

### Synopsis

List the execution modes accepted by --mode on session create, send, and run.

```
obey session modes [flags]
```

### Examples

```
  # All built-in modes
  obey session modes

  # Modes supported by a provider
  obey session modes --provider claude-code
```

### Options

```
  -h, --help              help for modes
      --json              output modes as JSON
  -p, --provider string   filter modes to one provider
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
