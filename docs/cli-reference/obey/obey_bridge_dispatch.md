---
title: "obey bridge dispatch"
linkTitle: "obey bridge dispatch"
description: "Route a provider's native hook event to the matching bridge verb"
---

## obey bridge dispatch

Route a provider's native hook event to the matching bridge verb

### Synopsis

Reads a provider's hook JSON payload from stdin once and re-dispatches it to register/heartbeat/activity/end, the same routing an obey-installed hook needs. A Claude Code or Codex PermissionRequest is relayed to the daemon and waits for an answer through obey; only then does stdout carry the decision. Fail-open, like every other bridge hook command -- this is meant to be invoked automatically by the provider's own hook runner, not typed by a human.

```
obey bridge dispatch <provider> [flags]
```

### Options

```
  -h, --help        help for dispatch
      --pid int32   agent process id, as reported by the provider's hook ($PPID)
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
