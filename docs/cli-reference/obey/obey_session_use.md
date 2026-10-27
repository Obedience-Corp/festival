---
title: "obey session use"
linkTitle: "obey session use"
description: "Set the current session for a campaign"
---

## obey session use

Set the current session for a campaign

### Synopsis

Set or clear the campaign-local current session used by session commands when no selector is provided.

```
obey session use <session-selector> [flags]
```

### Examples

```
  obey session use @builder
  obey session use --clear
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
      --clear             clear the current session for the campaign
  -h, --help              help for use
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
