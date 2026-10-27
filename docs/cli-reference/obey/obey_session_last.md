---
title: "obey session last"
linkTitle: "obey session last"
description: "Show the most recently active sessions, across all statuses"
---

## obey session last

Show the most recently active sessions, across all statuses

### Synopsis

Show sessions newest-first by last activity, regardless of status --
unlike "session list", which defaults to active sessions only. Use this to
answer "what were my last sessions" and to find a session to resume.

By default this lists within the current campaign (same resolution as
"session list"). Use --all-campaigns to search every campaign on this node.

```
obey session last [flags]
```

### Examples

```
  # Last 5 sessions in the current campaign
  obey session last --limit 5

  # Last 5 sessions across every campaign on this machine
  obey session last --all-campaigns --limit 5
```

### Options

```
      --all-campaigns   search every campaign on this node
  -h, --help            help for last
      --json            output sessions as JSON
      --limit uint32    maximum sessions to return (default 20)
      --resumable       show only resumable sessions
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
