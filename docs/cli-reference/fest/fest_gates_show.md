---
title: "fest gates show"
linkTitle: "fest gates show"
description: "Show effective gate policy"
---

## fest gates show

Show effective gate policy

### Synopsis

Display the effective gate policy for a festival, phase, or sequence.
Shows which gates are active and where each gate originated from.

```
fest gates show [flags]
```

### Examples

```
  fest gates show
  fest gates show --phase 002_IMPLEMENT
  fest gates show --sequence 002_IMPLEMENT/01_core --json
```

### Options

```
  -h, --help              help for show
      --json              Output in JSON format
      --phase string      Show gates for specific phase
      --sequence string   Show gates for specific sequence (format: phase/sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest gates](../fest_gates/)	 - Manage quality gates - validation steps at sequence end
