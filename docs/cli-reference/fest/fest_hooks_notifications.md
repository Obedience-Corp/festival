---
title: "fest hooks notifications"
linkTitle: "fest hooks notifications"
description: "Inspect machine-local workflow notifications"
---

## fest hooks notifications

Inspect machine-local workflow notifications

### Synopsis

Inspect presentation_open (entry into PRESENT) and approval_notify (human approval needed).
These optional notifications run after command execution and lock release. They never
approve checkpoints. Only explicitly enabled machine definitions apply; workspace and
festival definitions are ignored. Notifications always fail open and have bounded timeouts.
They are separate from the ordinary hooks shown by 'fest hooks list'.

```
fest hooks notifications [flags]
```

### Options

```
  -h, --help   help for notifications
      --json   Output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest hooks](../fest_hooks/)	 - Inspect resolved lifecycle hooks
