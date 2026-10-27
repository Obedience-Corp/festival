---
title: "obey service"
linkTitle: "obey service"
description: "Supervise the daemon with the operating system service manager"
---

## obey service

Supervise the daemon with the operating system service manager

### Synopsis

Register the daemon with launchd (macOS), systemd --user (Linux), or a
per-user Task Scheduler task (Windows) so it starts at login and restarts after
a crash.

Without a service, ob can start the daemon on demand, but nothing keeps it
running across sign-ins or crashes until another client asks for it.

### Options

```
  -h, --help   help for service
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey service install](../obey_service_install/)	 - Install the daemon service
* [obey service restart](../obey_service_restart/)	 - Reload the unit and restart the supervised daemon
* [obey service status](../obey_service_status/)	 - Report whether the daemon service is installed, loaded, and answering
* [obey service uninstall](../obey_service_uninstall/)	 - Stop the daemon service and remove its unit file
