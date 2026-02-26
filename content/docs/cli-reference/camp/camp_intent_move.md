## camp intent move

Move intent to a different status

### Synopsis

Transition an intent between lifecycle statuses.

VALID STATUSES:
  inbox    Captured, not yet reviewed
  active   Being enriched with details
  ready    Ready for Festival promotion
  done     Resolved
  killed   Abandoned

VALID TRANSITIONS:
  inbox  → active, killed
  active → ready, inbox, killed
  ready  → done, active, killed
  killed → inbox (un-kill)

Examples:
  camp intent move add-dark active        Move to active status
  camp intent move add-dark ready         Mark as ready for promotion
  camp intent move add-dark done          Mark as complete
  camp intent move add-dark killed        Archive/abandon intent

```
camp intent move <id> <status> [flags]
```

### Options

```
  -h, --help        help for move
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

