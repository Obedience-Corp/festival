---
title: "obey service restart"
linkTitle: "obey service restart"
description: "Reload the unit and restart the supervised daemon"
---

## obey service restart

Reload the unit and restart the supervised daemon

### Synopsis

Hand the running daemon back to its supervisor, after making the supervisor
re-read the unit file on disk.

The reload is what makes this the verb to run after an upgrade. An install
rewrites the unit and leaves a running daemon alone, so until something reloads
it the supervisor is still enforcing the definition it was given last time: on
macOS that means the previous executable path, the previous PATH, and launchd's
default 20-second stop timeout, which leaves the daemon's own 20-second shutdown
budget no margin at all. macOS reloads with launchctl bootout then bootstrap,
Linux with systemctl --user daemon-reload.

It then waits for the outgoing process to exit and the replacement to answer on
the socket, rather than reporting success on the first Ping, which the outgoing
daemon answers until its drain is done.

With no unit installed it refuses instead of starting an unsupervised daemon.

```
obey service restart [flags]
```

### Options

```
  -h, --help   help for restart
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey service](../obey_service/)	 - Supervise the daemon with the operating system service manager
