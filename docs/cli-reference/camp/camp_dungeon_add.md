## camp dungeon add

Initialize dungeon structure

### Synopsis

Initialize the dungeon directory with documentation and structure.

Creates the dungeon directory with:
  - OBEY.md: Documentation explaining the dungeon's purpose
  - completed/: Successfully finished work
  - archived/: Preserved for history, truly done
  - someday/: Low priority, might revisit

This creates the same dungeon structure as 'camp flow init' but without
the full workflow (no .workflow.yaml, active/, or ready/ directories).
Useful when you only need a dungeon for idea capture or temporary holding.

This operation is idempotent - running it multiple times is safe.
Use --force to overwrite existing files.

Examples:
  camp dungeon add          Initialize dungeon (skip existing files)
  camp dungeon add --force  Overwrite existing documentation

```
camp dungeon add [flags]
```

### Options

```
  -f, --force   Overwrite existing files
  -h, --help    help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp dungeon](camp_dungeon.md)	 - Manage the campaign dungeon

