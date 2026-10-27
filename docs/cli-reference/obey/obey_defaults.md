---
title: "obey defaults"
linkTitle: "obey defaults"
description: "Inspect the shipped defaults this binary carries"
---

## obey defaults

Inspect the shipped defaults this binary carries

### Synopsis

Report the versioned defaults obey computes a budget and a fit table from.

The class table, the footprint geometry, the tier values, and the starter model
set are estimates about hardware and about models, and both change. Each one
carries a version and a content hash so a stale set is visible rather than
silent.

This is read-only. It never writes a file and never changes a default.

### Options

```
  -h, --help   help for defaults
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey defaults adopt](../obey_defaults_adopt/)	 - Take a newer defaults set (not implemented in this release)
* [obey defaults status](../obey_defaults_status/)	 - Report the defaults this binary carries and whether a newer set exists
