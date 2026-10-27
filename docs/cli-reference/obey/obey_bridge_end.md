---
title: "obey bridge end"
linkTitle: "obey bridge end"
description: "Mark a bridged external session ended"
---

## obey bridge end

Mark a bridged external session ended

```
obey bridge end [flags]
```

### Options

```
      --campaign string     campaign name or UUID; defaults to bridge state, cwd inference, then unassigned
      --cwd string          working directory for campaign inference
  -h, --help                help for end
      --session-id string   provider-native hook/session id or daemon session id
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
