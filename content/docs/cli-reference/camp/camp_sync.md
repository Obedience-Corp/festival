## camp sync

Safely synchronize submodules

### Synopsis

Synchronize submodules with pre-flight safety checks.

The sync command performs three critical operations:

  1. PRE-FLIGHT CHECKS
     Verifies no uncommitted changes or unpushed commits that could
     be lost during synchronization.

  2. URL SYNCHRONIZATION
     Copies URLs from .gitmodules to .git/config, fixing URL mismatches
     that occur when remote URLs change.

  3. SUBMODULE UPDATE
     Fetches and checks out the correct commits for all submodules.

This order is critical: sync-before-update prevents silent code deletion
when URLs change on remote repositories.

EXIT CODES:
  0  Success
  1  Pre-flight check failed (uncommitted changes)
  2  Sync or update operation failed
  3  Post-sync validation failed
  4  Invalid arguments

EXAMPLES:
  # Sync all submodules (recommended default)
  camp sync

  # Preview what would happen without making changes
  camp sync --dry-run

  # Sync a specific submodule only
  camp sync projects/camp

  # Force sync despite uncommitted changes (dangerous!)
  camp sync --force

  # Detailed output for each submodule
  camp sync --verbose

  # JSON output for scripting
  camp sync --json

```
camp sync [submodule...] [flags]
```

### Options

```
  -n, --dry-run        Show what would happen without making changes
  -f, --force          Skip safety checks (uncommitted changes warning still shown)
  -h, --help           help for sync
      --json           Output results as JSON for scripting
      --no-fetch       Skip fetching from remote (use local refs only)
  -p, --parallel int   Number of parallel git operations (default 4)
  -v, --verbose        Show detailed output for each submodule
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

