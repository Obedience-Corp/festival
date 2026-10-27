---
title: "obey session approve"
linkTitle: "obey session approve"
description: "Approve or deny a pending supervised tool call"
---

## obey session approve

Approve or deny a pending supervised tool call

### Synopsis

Approve or deny a pending supervised tool call by call id in the current campaign.

```
obey session approve <call-id> [flags]
```

### Examples

```
  obey session approve call_123
  obey session approve call_123 --deny --reason "not safe"
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
      --deny              deny the pending approval instead of approving it
  -h, --help              help for approve
      --reason string     reason to include with the approval decision
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
