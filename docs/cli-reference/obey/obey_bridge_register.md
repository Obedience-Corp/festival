---
title: "obey bridge register"
linkTitle: "obey bridge register"
description: "Register an externally managed provider session"
---

## obey bridge register

Register an externally managed provider session

### Synopsis

Register an externally managed provider session with the local daemon. Hook defaults are silent and fail open.

```
obey bridge register [flags]
```

### Options

```
      --agent string        agent name for the external session (default "claude-code")
      --campaign string     campaign name or UUID; defaults to cwd inference, then unassigned
      --cwd string          working directory to associate with the external session
  -h, --help                help for register
      --model string        model label for the external session (default "claude-code")
      --pid int32           external session process id when available
      --provider string     provider name for the external session (default "claude-code")
      --session-id string   provider-native hook/session id
```

### Options inherited from parent commands

```
      --debug           print bridge hook diagnostics instead of staying silent
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey bridge](../obey_bridge/)	 - Bridge external terminal sessions into obey
