## fest migrate metadata

Add metadata to existing festivals

### Synopsis

Migrate existing festivals to use the ID system.

This command:
1. Generates a unique ID for festivals without one
2. Adds metadata to fest.yaml (ID, UUID, creation time)
3. Renames the festival directory to include the ID suffix

The migration is idempotent - running it multiple times is safe.

Examples:
  fest migrate metadata                    # Migrate all festivals
  fest migrate metadata ./active/my-fest   # Migrate specific festival
  fest migrate metadata --dry-run          # Preview changes only

```
fest migrate metadata [path] [flags]
```

### Options

```
      --dry-run   preview changes without making them
  -h, --help      help for metadata
  -v, --verbose   show detailed progress
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest migrate](fest_migrate.md)	 - Migrate festival documents

