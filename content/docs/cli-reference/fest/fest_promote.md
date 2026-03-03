## fest promote

Promote a festival to the next lifecycle status

### Synopsis

Promote moves a festival through the lifecycle: planning → ready → active → completed.

Each transition validates readiness:
  planning → ready:    Festival goal must be defined
  ready → active:      Festival is ready to begin execution
  active → completed:  All tasks must be completed

Use --dungeon to send a festival directly to a dungeon status:
```bash
  fest promote --dungeon someday     Shelve for later
  fest promote --dungeon archived    Archive the festival
  fest promote --dungeon completed   Mark as completed (skips task validation)
```

```
fest promote [flags]
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
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

