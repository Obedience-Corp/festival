## camp unregister

Remove campaign from registry

### Synopsis

Remove a campaign from the global registry.

This does NOT delete any files - it only removes the campaign from
tracking in the global registry. Use this when:
  - A campaign directory was deleted manually
  - A campaign was moved to a different location
  - You no longer want to track a campaign

The campaign files remain untouched on disk.

You can specify the campaign by name or ID (or ID prefix).

Examples:
  camp unregister old-project            # Remove by name
  camp unregister 550e84                 # Remove by ID prefix
  camp unregister old-project --force    # Remove without confirmation

```
camp unregister <name-or-id> [flags]
```

### Options

```
  -f, --force   Skip confirmation prompt
  -h, --help    help for unregister
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

