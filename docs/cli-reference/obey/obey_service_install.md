---
title: "obey service install"
linkTitle: "obey service install"
description: "Install the daemon service"
---

## obey service install

Install the daemon service

### Synopsis

Register the daemon with launchd (macOS), systemd --user (Linux), or
Task Scheduler (Windows), and start it when nothing is running yet.

A daemon that is already running is left alone: the unit on disk is refreshed
and the running process keeps serving until something restarts it, so upgrading
obey never interrupts work in flight. Pass --restart to replace it now.

```
obey service install [flags]
```

### Options

```
  -h, --help      help for install
      --restart   restart a daemon that is already running so it picks up this binary
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey service](../obey_service/)	 - Supervise the daemon with the operating system service manager
