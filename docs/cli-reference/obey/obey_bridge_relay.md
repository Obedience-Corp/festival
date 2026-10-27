---
title: "obey bridge relay"
linkTitle: "obey bridge relay"
description: "Serve input for one bridged session's Ghostty terminal (macOS)"
---

## obey bridge relay

Serve input for one bridged session's Ghostty terminal (macOS)

### Synopsis

Runs the per-session input relay a SessionStart hook spawns inside Ghostty on macOS. It inherits Ghostty's Apple Events responsibility, listens on /tmp/obey-relay-<first 8 of the obey session id>.sock, re-verifies the captured terminal before every send, key, or control operation, and exits on SessionEnd (socket removed), when the agent process exits, or when another relay replaces its socket. Started by `obey bridge dispatch`, not typed by a human.

```
obey bridge relay [flags]
```

### Options

```
      --agent-pid int     agent process id; the relay exits when it is gone
      --agent-start int   agent process start time (unix microseconds) binding --agent-pid against reuse
      --cwd string        session working directory the terminal must still report
  -h, --help              help for relay
      --provider string   provider name, whose bare title marks an exited agent
      --session string    obey session id the relay serves
      --terminal string   Ghostty terminal id captured at SessionStart
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
