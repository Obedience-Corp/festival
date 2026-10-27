---
title: "obey bridge install"
linkTitle: "obey bridge install"
description: "Install obey's bridge hook for a provider"
---

## obey bridge install

Install obey's bridge hook for a provider

```
obey bridge install <provider|all> [flags]
```

### Options

```
  -h, --help           help for install
      --print          print the merged config without writing it
      --scope string   install scope: campaign or user (default "campaign")
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
