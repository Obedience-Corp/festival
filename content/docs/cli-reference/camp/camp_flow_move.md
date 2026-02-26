## camp flow move

Move an item to a new status

### Synopsis

Move an item from its current status to a new status.

The item is moved from wherever it currently exists to the specified status.
Transitions are validated against the workflow schema unless --force is used.

Auto-commit behavior is controlled by .workflow.yaml auto_commit settings.
Use --commit to force a commit or --no-commit to skip it.

Examples:
  camp flow move project-1 ready             Move to ready/
  camp flow move old-project dungeon/completed   Move to dungeon/completed/
  camp flow move project-1 ready --reason "Ready for review"
  camp flow move project-1 active --force    Force move (skip validation)
  camp flow move project-1 ready --commit    Force auto-commit

```
camp flow move <item> <status> [flags]
```

### Options

```
      --commit          force auto-commit after move
  -f, --force           force move (skip transition validation)
  -h, --help            help for move
      --no-commit       skip auto-commit even if enabled in config
  -r, --reason string   reason for the move
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

