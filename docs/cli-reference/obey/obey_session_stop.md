---
title: "obey session stop"
linkTitle: "obey session stop"
description: "Stop a running session"
---

## obey session stop

Stop a running session

```
obey session stop [session-selector] [flags]
```

### Options

```
  -a, --agent string      filter --where targets by agent name
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -g, --group string      filter --where targets by group ID
  -h, --help              help for stop
      --mode string       filter --where targets by execution mode
  -p, --provider string   filter --where targets by provider
      --tree              stop session and all descendants
      --where string      batch stop filter; currently supports status=<status>
      --yes               confirm stopping multiple sessions selected by --where
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
