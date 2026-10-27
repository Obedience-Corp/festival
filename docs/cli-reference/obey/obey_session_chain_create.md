---
title: "obey session chain create"
linkTitle: "obey session chain create"
description: "Create a watch chain between two sessions"
---

## obey session chain create

Create a watch chain between two sessions

### Synopsis

Create a watch chain that forwards completions from the source
session to the target session. The chain runs in the daemon and
returns immediately unless --follow is specified.

Examples:
  # Create and return (scriptable)
  obey session chain create abc123 def456

  # Create with JSON output for scripting
  obey session chain create abc123 def456 --json

  # Create with file relay mode
  obey session chain create abc123 def456 --mode file

  # Create and follow (block until Ctrl+C)
  obey session chain create abc123 def456 --follow

```
obey session chain create <source-session-id> <target-session-id> [flags]
```

### Options

```
  -c, --campaign string    campaign name or UUID (defaults to the campaign at the current working directory)
  -f, --follow             block and follow chain activity (Ctrl+C to stop)
  -h, --help               help for create
      --json               output chain info as JSON (for scripting)
      --mode string        relay mode: "grpc" (direct, low latency) or "file" (via relay file) (default "grpc")
      --relay-dir string   directory for relay files (file mode only, defaults to system temp dir)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session chain](../obey_session_chain/)	 - Manage watch chains between sessions
