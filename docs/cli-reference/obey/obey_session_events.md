---
title: "obey session events"
linkTitle: "obey session events"
description: "Show stored session events"
---

## obey session events

Show stored session events

### Synopsis

Show durable daemon history events for a campaign, group, or selected session.

```
obey session events [session-selector] [flags]
```

### Options

```
  -c, --campaign string    campaign name or UUID (defaults to the campaign at the current working directory)
      --cursor string      resume from a previous event cursor
  -g, --group string       filter by group ID
  -h, --help               help for events
      --json               output event response as JSON
      --kind stringArray   filter by event kind; may be repeated
      --limit uint32       maximum events to return
      --newest-first       show newest events first
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
