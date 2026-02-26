## camp flow sync

Sync directories with schema

### Synopsis

Synchronize directories with the workflow schema.

Creates any directories defined in .workflow.yaml that don't exist yet.
Does not remove directories that aren't in the schema.

Use --dry-run to see what would be created without making changes.

Examples:
  camp flow sync              Create missing directories
  camp flow sync --dry-run    Preview changes without creating

```
camp flow sync [flags]
```

### Options

```
  -n, --dry-run   preview changes without creating directories
  -h, --help      help for sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

