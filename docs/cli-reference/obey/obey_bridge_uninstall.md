---
title: "obey bridge uninstall"
linkTitle: "obey bridge uninstall"
description: "Remove obey-owned bridge hooks without touching foreign configuration"
---

## obey bridge uninstall

Remove obey-owned bridge hooks without touching foreign configuration

```
obey bridge uninstall <provider|all> [flags]
```

### Options

```
  -h, --help           help for uninstall
      --print          print the config after removing obey-owned entries without writing it
      --scope string   uninstall scope: campaign or user (default "campaign")
```

### Options inherited from parent commands

```
      --debug           print bridge hook diagnostics instead of staying silent
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey bridge](../obey_bridge/)	 - Bridge external terminal sessions into obey
