---
title: "obey service status"
linkTitle: "obey service status"
description: "Report whether the daemon service is installed, loaded, and answering"
---

## obey service status

Report whether the daemon service is installed, loaded, and answering

```
obey service status [flags]
```

### Options

```
  -h, --help   help for status
      --json   emit the service report as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey service](../obey_service/)	 - Supervise the daemon with the operating system service manager
