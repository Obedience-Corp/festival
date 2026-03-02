## camp refs-sync

Sync submodule ref pointers in campaign root

### Synopsis

Update the campaign root's recorded submodule pointers to match
each submodule's current HEAD. Creates a single atomic commit.

Without arguments, syncs all submodules. Specify paths to sync specific ones.

Examples:
  camp refs-sync                      # Sync all dirty refs
  camp refs-sync projects/camp        # Sync specific submodule
  camp refs-sync --dry-run            # Show plan without executing

```
camp refs-sync [submodule...] [flags]
```

### Options

```
  -n, --dry-run   Show plan without executing
  -f, --force     Skip safety checks (staged changes)
  -h, --help      help for refs-sync
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

