---
title: "camp fresh all"
linkTitle: "camp fresh all"
description: "Run fresh across all project submodules"
---

## camp fresh all

Run fresh across all project submodules

### Synopsis

Run the fresh cycle (checkout default, pull, prune, optional branch)
across every project submodule in the campaign.

Examples:
  camp fresh all                     # Sync all projects
  camp fresh all --branch develop    # Sync all and create develop branch
  camp fresh all --dry-run           # Preview across all projects
  camp fresh all --no-prune          # Sync without pruning

```
camp fresh all [flags]
```

### Options

```
  -h, --help   help for all
```

### Options inherited from parent commands

```
  -b, --branch string   Branch to create after syncing (overrides config)
      --config string   config file (default: ~/.obey/campaign/config.json)
  -n, --dry-run         Preview without making changes
      --no-branch       Skip branch creation even if configured
      --no-color        disable colored output
      --no-prune        Skip pruning merged branches
      --no-push         Skip pushing the new branch upstream
      --verbose         enable verbose output
```

### SEE ALSO

* [camp fresh](../camp_fresh/)	 - Post-merge branch cycling: sync to default branch and optionally create a new working branch
