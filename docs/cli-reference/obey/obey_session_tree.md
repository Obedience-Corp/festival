---
title: "obey session tree"
linkTitle: "obey session tree"
description: "Display session hierarchy as a tree"
---

## obey session tree

Display session hierarchy as a tree

```
obey session tree <session-id> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for tree
      --json              output session tree as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
