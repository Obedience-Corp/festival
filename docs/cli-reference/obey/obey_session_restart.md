---
title: "obey session restart"
linkTitle: "obey session restart"
description: "Restart a stopped or failed session"
---

## obey session restart

Restart a stopped or failed session

### Synopsis

Restart a session, carrying its metadata forward and resuming the provider conversation when the provider session is resumable.

```
obey session restart <session-selector> [flags]
```

### Examples

```
  # Revive a session that failed on daemon restart
  obey session restart 7fcde681-09ea-4ef7-b433-40053b6eaeeb

  # Restart the active session for an agent
  obey session restart agent:builder

  # Restart a live session at a different reasoning effort
  obey session restart 7fcde681 --reasoning-effort low
```

### Options

```
  -c, --campaign string           campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help                      help for restart
      --json                      output restarted session as JSON
      --model string              restart under a different model; refused when resuming a conversation in place
      --provider string           restart under a different provider; refused when resuming a conversation in place
      --reasoning-effort string   reasoning effort for the new conversation (stored as obey.reasoning_effort; the rest of the session config is kept): none, low, medium, high, xhigh, or max; refused for providers that cannot apply it; refused when resuming a conversation in place
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
