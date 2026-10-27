---
title: "obey devices approve"
linkTitle: "obey devices approve"
description: "Approve a pending pairing request"
---

## obey devices approve

Approve a pending pairing request

```
obey devices approve <pairing-request-id> [flags]
```

### Options

```
      --code-file string   read the device-displayed pairing code from a file or stdin (-) (default "-")
  -h, --help               help for approve
```

### Options inherited from parent commands

```
      --json            emit machine-readable JSON
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey devices](../obey_devices/)	 - Manage devices paired with this daemon
