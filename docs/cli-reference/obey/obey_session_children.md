---
title: "obey session children"
linkTitle: "obey session children"
description: "List direct children of a session"
---

## obey session children

List direct children of a session

```
obey session children <session-id> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for children
      --json              output session children as JSON
  -s, --status string     filter by status
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
