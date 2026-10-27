---
title: "obey observe"
linkTitle: "obey observe"
description: "Observe recent and live session activity"
---

## obey observe

Observe recent and live session activity

### Synopsis

Show recent daemon-backed session activity and optionally follow live activity.

```
obey observe [flags]
```

### Options

```
  -c, --campaign string        campaign name or UUID (defaults to the campaign at the current working directory)
      --cursor string          resume recent activity from a previous cursor
      --follow                 follow live activity after the recent tail
  -g, --group string           filter by group ID
  -h, --help                   help for observe
      --json                   output activity responses as JSON
      --lifecycle              include session lifecycle events in human output
      --mode string            filter by execution mode
      --selector stringArray   target selector: id:<session>, agent:<name>, @<name>, or session ID/prefix; may be repeated
      --session stringArray    filter by exact session ID; may be repeated
      --status stringArray     filter by session status; may be repeated
      --tail uint32            number of recent activity events to show before following; use 0 to skip (default 20)
      --type stringArray       filter by activity type; may be repeated
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
