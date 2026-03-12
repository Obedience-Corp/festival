## camp registry prune

Remove stale registry entries

### Synopsis

Remove registry entries where the campaign no longer exists.

Checks each registered path and removes entries where:
- The path no longer exists
- The path has no .campaign/ directory

Options:
  --dry-run       Show what would be removed without making changes
  --include-temp  Also remove entries in /tmp/ directories

Examples:
  camp registry prune             Remove stale entries
  camp registry prune --dry-run   Preview what would be removed
  camp registry prune --include-temp  Also clean up test campaigns

```
camp registry prune [flags]
```

### Options

```
      --dry-run        Show what would be removed without making changes
  -h, --help           help for prune
      --include-temp   Also remove entries in /tmp/ directories
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp registry](camp_registry.md)	 - Manage the campaign registry

