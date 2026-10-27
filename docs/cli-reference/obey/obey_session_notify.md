---
title: "obey session notify"
linkTitle: "obey session notify"
description: "Deliver a durable one-shot notification to a session"
---

## obey session notify

Deliver a durable one-shot notification to a session

### Synopsis

Read an obey.session.notification/v1 envelope as JSON on stdin and submit it
to the daemon for durable, idempotent, turn-boundary delivery to the exact
target session.

The envelope is read from stdin (never shell arguments) so feedback text is
never interpreted by the shell. The daemon records the request before any
delivery, deduplicates by delivery_id, rejects external-session targets and
campaign mismatches, and delivers at the next turn boundary. It is used by
producers such as the Fest judge continuation path.

```
obey session notify [flags]
```

### Examples

```
  cat notification.json | obey session notify
  obey session notify --json < notification.json
```

### Options

```
  -h, --help   help for notify
      --json   output the notify result as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
