---
title: "fest promote"
linkTitle: "fest promote"
description: "Promote a festival to the next lifecycle status"
---

## fest promote

Promote a festival to the next lifecycle status

### Synopsis

Promote moves a festival through the lifecycle: planning → ready → active → completed.

Each transition validates readiness:
  planning → ready:    Festival goal must be defined
  ready → active:      Festival is ready to begin execution
  active → completed:  All tasks must be completed

By default, promotes the festival you are currently inside. From elsewhere in a
campaign, pass a festival name or run promote interactively to pick one:
```bash
  fest promote my-feature       Promote a festival by name (tab completion)
  fest promote                  Pick a festival from a fuzzy picker (in a terminal)
```

Use --dungeon to send a festival directly to a dungeon status:
```bash
  fest promote --dungeon someday     Shelve for later
  fest promote --dungeon archived    Archive the festival
  fest promote --dungeon completed   Mark as completed (skips task validation)
```

```
fest promote [festival] [flags]
```

### Options

```
      --dungeon string   send to dungeon status (completed, archived, someday)
      --force            skip readiness validation
  -h, --help             help for promote
      --json             output as JSON
      --no-commit        skip auto-commit after promotion
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
