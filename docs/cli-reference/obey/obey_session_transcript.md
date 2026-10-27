---
title: "obey session transcript"
linkTitle: "obey session transcript"
description: "Show a stored session transcript"
---

## obey session transcript

Show a stored session transcript

### Synopsis

Show a stored daemon-backed transcript for a session selector.

```
obey session transcript <session-selector> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
      --cursor string     resume from a previous transcript cursor
  -h, --help              help for transcript
      --json              output transcript response as JSON
      --limit uint32      maximum transcript entries to return
      --newest-first      show newest transcript entries first
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
