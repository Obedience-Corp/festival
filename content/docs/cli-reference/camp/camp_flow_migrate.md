## camp flow migrate

Migrate workflow to latest schema version

### Synopsis

Migrate a workflow to the latest schema version.

Supports two migration paths:
  - Legacy dungeon → v1 workflow (creates .workflow.yaml)
  - v1 → v2 (dungeon-centric model)

For v1→v2 migration:
  - active/ items move to root directory
  - ready/ items move to dungeon/ready/
  - Empty active/ and ready/ directories are removed
  - Schema is updated to version 2

Use --dry-run to preview changes without applying them.
Use --force to skip confirmation prompts.

Examples:
  camp flow migrate            Migrate with confirmation
  camp flow migrate --dry-run  Preview migration
  camp flow migrate --force    Migrate without confirmation

```
camp flow migrate [flags]
```

### Options

```
  -n, --dry-run   preview migration without making changes
  -f, --force     skip confirmation
  -h, --help      help for migrate
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

