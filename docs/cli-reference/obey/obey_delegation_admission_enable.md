---
title: "obey delegation admission enable"
linkTitle: "obey delegation admission enable"
description: "Enable managed delegation admissions"
---

## obey delegation admission enable

Enable managed delegation admissions

### Synopsis

Toggle admission of new managed delegations on the daemon's owner-only Unix socket.

The command never dials TCP; it resolves the configured socket and opens it as
a Unix transport only.

```
obey delegation admission enable [flags]
```

### Options

```
  -h, --help   help for enable
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey delegation admission](../obey_delegation_admission/)	 - Control whether new delegations are admitted
