---
title: "obey doctor"
linkTitle: "obey doctor"
description: "Check daemon health"
---

## obey doctor

Check daemon health

### Synopsis

Run daemon health checks and print [PASS], [WARN], [FAIL], or [SKIP] results. Returns a non-zero exit code if any required check fails.

```
obey doctor [flags]
```

### Options

```
      --capture   write a contributable hardware capability record to the current directory and exit
  -h, --help      help for doctor
      --json      emit a machine-readable health and CLI capability report
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
