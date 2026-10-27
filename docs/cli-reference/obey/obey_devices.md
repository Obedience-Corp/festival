---
title: "obey devices"
linkTitle: "obey devices"
description: "Manage devices paired with this daemon"
---

## obey devices

Manage devices paired with this daemon

### Synopsis

Interactively approve pending device pairings and inspect paired devices over the owner-only Unix socket.

```
obey devices [flags]
```

### Options

```
  -h, --help   help for devices
      --json   emit machine-readable JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey devices approve](../obey_devices_approve/)	 - Approve a pending pairing request
* [obey devices deny](../obey_devices_deny/)	 - Deny a pending pairing request
* [obey devices list](../obey_devices_list/)	 - List paired devices
* [obey devices pending](../obey_devices_pending/)	 - List pending pairing requests
* [obey devices rename](../obey_devices_rename/)	 - Rename a paired device
* [obey devices revoke](../obey_devices_revoke/)	 - Revoke a paired device
* [obey devices revoke-all](../obey_devices_revoke-all/)	 - Revoke every active paired device
