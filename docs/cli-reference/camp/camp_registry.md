## camp registry

Manage the campaign registry

### Synopsis

Manage the campaign registry at ~/.obey/campaign/registry.json.

The registry tracks all known campaigns for quick navigation and lookup.
Use these commands to maintain registry health and resolve issues.

Commands:
  prune   Remove stale entries (campaigns that no longer exist)
  sync    Update registry entry for current campaign
  check   Validate registry integrity

Examples:
  camp registry prune             Remove entries for non-existent campaigns
  camp registry prune --dry-run   Show what would be removed
  camp registry sync              Update path for current campaign
  camp registry check             Check for issues

### Options

```
  -h, --help   help for registry
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp registry check](camp_registry_check.md)	 - Check registry integrity
* [camp registry prune](camp_registry_prune.md)	 - Remove stale registry entries
* [camp registry sync](camp_registry_sync.md)	 - Sync current campaign with registry

