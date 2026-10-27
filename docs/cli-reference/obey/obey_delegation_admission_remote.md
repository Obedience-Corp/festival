---
title: "obey delegation admission remote"
linkTitle: "obey delegation admission remote"
description: "Control new remote A2A admissions"
---

## obey delegation admission remote

Control new remote A2A admissions

### Synopsis

Toggle admission of new outbound remote A2A delegations on the daemon's
owner-only Unix socket. Without --target this changes the global remote gate;
with --target it changes one configured target profile.

### Options

```
  -h, --help            help for remote
      --target string   named remote target profile (empty changes the global gate)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey delegation admission](../obey_delegation_admission/)	 - Control whether new delegations are admitted
* [obey delegation admission remote disable](../obey_delegation_admission_remote_disable/)	 - Disable remote A2A admissions
* [obey delegation admission remote enable](../obey_delegation_admission_remote_enable/)	 - Enable remote A2A admissions
