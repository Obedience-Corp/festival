## fest workflow reset

Reset workflow to step 1

### Synopsis

Reset the workflow state back to step 1.

This clears all step progress and starts the workflow from the beginning.
Use with caution as this cannot be undone.

```
fest workflow reset [flags]
```

### Options

```
      --force   Skip confirmation prompt
  -h, --help    help for reset
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

