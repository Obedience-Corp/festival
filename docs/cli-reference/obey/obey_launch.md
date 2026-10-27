---
title: "obey launch"
linkTitle: "obey launch"
description: "Start a new provider-backed session through obey"
---

## obey launch

Start a new provider-backed session through obey

### Synopsis

Start a session that obey owns and drives.

This is the acquisition path where obey launches the provider itself, as
opposed to a bridge registering a session something else started. Both produce
rows of the same shape in the same ledger.

Without --attach the command prints the session ref and exits immediately; it
needs no terminal and is safe to script. With --attach it stays and streams the
session's activity, exactly as "obey session attach" would.

```
obey launch <provider> [flags]
```

### Examples

```
  # Start a session and get its ref
  obey launch claude-code

  # Start one that should not be respun after a crash, and watch it
  obey launch claude-code --disposition disposable --attach

  # Pin the model and working directory
  obey launch openai --model gpt-5.4 --cwd ./services/api
```

### Options

```
      --agent string           agent name for the session
      --agent-profile string   operator-owned authority profile for the session
      --attach                 stream the session's activity after launching it
  -c, --campaign string        campaign name or UUID (defaults to the campaign at the current working directory)
  -w, --cwd string             working directory for the launched session
      --disposition string     durable (respin after a crash) or disposable (leave dead); defaults to durable
  -h, --help                   help for launch
      --json                   output the created session as JSON
      --mode string            initial execution mode (must match --agent-profile when set)
  -m, --model string           model name (defaults to the provider's configured model)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
