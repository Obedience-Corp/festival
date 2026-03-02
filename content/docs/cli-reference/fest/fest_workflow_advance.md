## fest workflow advance

Complete current step and move to next

### Synopsis

Mark the current workflow step as complete and advance to the next step.

This command:
  1. Marks the current step as completed
  2. Advances the workflow to the next step
  3. Saves the updated state

Note: If the current step has a blocking checkpoint, use 'fest workflow approve' instead.

```
fest workflow advance [flags]
```

### Options

```
  -h, --help   help for advance
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest workflow](fest_workflow.md)	 - Manage workflow-based phase execution

