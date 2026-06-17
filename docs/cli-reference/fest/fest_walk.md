---
title: "fest walk"
linkTitle: "fest walk"
description: "Guided overview of a festival"
---

## fest walk

Guided overview of a festival

### Synopsis

Display a guided orientation overview of a festival.

Shows what the festival is, where it is, its current status and progress,
the next task, blocked tasks, active quality gates, and any warnings.
This is a read-only orientation command; it never mutates festival state.

Useful for quickly orienting inside a festival before continuing work,
especially for rituals where the template and active run are distinct.

EXAMPLES:
```bash
  fest walk                      # Walk current festival from cwd
  fest walk festivals/active/my-festival
  fest walk --json               # Machine-readable output
```

```
fest walk [path] [flags]
```

### Options

```
      --from string   festival path (defaults to current directory)
  -h, --help          help for walk
      --json          output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
