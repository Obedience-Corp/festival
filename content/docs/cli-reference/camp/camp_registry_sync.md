## camp registry sync

Sync current campaign with registry

### Synopsis

Update the registry entry for the current campaign.

Run this after moving a campaign directory to update its path
in the registry. Reads the campaign ID from .campaign/campaign.yaml
and updates (or adds) the registry entry.

Examples:
  camp registry sync   # Run from inside a campaign

```
camp registry sync [flags]
```

### Options

```
  -h, --help   help for sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp registry](camp_registry.md)	 - Manage the campaign registry

