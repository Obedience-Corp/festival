## camp intent move

Move intent to a different status

### Synopsis

Transition an intent between lifecycle statuses.

VALID STATUSES:
  inbox      Captured, not yet reviewed
  ready      Reviewed/enriched, ready to be promoted
  active     Promoted to festival/design, work in progress
  done       Resolved (dungeon)
  killed     Abandoned (dungeon)
  archived   Preserved but inactive (dungeon)
  someday    Deferred (dungeon)

PIPELINE ORDER:
  inbox → ready → active → dungeon/done

Move is an escape hatch that allows any-to-any transitions.
Dungeon moves require a --reason flag.
You can use short dungeon names (done) or canonical paths (dungeon/done).

Examples:
  camp intent move add-dark ready                         Mark as ready
  camp intent move add-dark done --reason "completed"     Mark as done
  camp intent move add-dark killed --reason "superseded"  Kill intent

```
camp intent move <id> <status> [flags]
```

### Options

```
  -h, --help            help for move
      --no-commit       Don't create a git commit
      --reason string   Reason for the move (required for dungeon targets)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

