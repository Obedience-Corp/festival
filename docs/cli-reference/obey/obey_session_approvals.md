---
title: "obey session approvals"
linkTitle: "obey session approvals"
description: "List pending supervised tool approvals"
---

## obey session approvals

List pending supervised tool approvals

### Synopsis

List pending supervised tool approvals for the current campaign.

```
obey session approvals [flags]
```

### Examples

```
  obey session approvals
  obey session approvals --campaign my-campaign --json
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for approvals
      --json              output pending approvals as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
