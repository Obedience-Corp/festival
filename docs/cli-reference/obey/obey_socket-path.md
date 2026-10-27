---
title: "obey socket-path"
linkTitle: "obey socket-path"
description: "Print the resolved daemon socket path"
---

## obey socket-path

Print the resolved daemon socket path

### Synopsis

Print the daemon Unix socket path selected by --socket, environment,
configuration, or the canonical default.

The command does not contact the daemon. Its stdout is a single path suitable
for scripts and remote SSH probes. Configuration errors are returned instead
of falling back silently.

```
obey socket-path [flags]
```

### Options

```
  -h, --help   help for socket-path
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
