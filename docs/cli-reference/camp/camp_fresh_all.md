---
title: "camp fresh all"
linkTitle: "camp fresh all"
description: "Run fresh across all project submodules"
---

## camp fresh all

Run fresh across all project submodules

### Synopsis

Run the fresh cycle (fetch and safely sync default, prune, optional branch)
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
  -h, --help       help for all
      --no-drain   Do not wait for camp's queued commits first
```

### Options inherited from parent commands

```
  -b, --branch string   Branch to create after syncing (overrides config)
  -n, --dry-run         Preview without making changes
      --no-branch       Skip branch creation even if configured
      --no-color        disable colored output
      --no-follow-up    Skip configured follow-up command workflows
      --no-prune        Skip pruning merged branches
      --no-push         Skip pushing the new branch upstream
```

### SEE ALSO

* [camp fresh](../camp_fresh/)	 - Post-merge branch cycling: sync to default branch and optionally create a new working branch
