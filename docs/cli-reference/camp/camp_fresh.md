---
title: "camp fresh"
linkTitle: "camp fresh"
description: "Post-merge branch cycling: sync to default branch and optionally create a new working branch"
---

## camp fresh

Post-merge branch cycling: sync to default branch and optionally create a new working branch

### Synopsis

Reset one or more projects to a fresh state after merging a PR.

Performs the post-merge cycle: checkout default branch, pull latest,
prune merged branches, and optionally create a new working branch.

Auto-detects the current project from your working directory, or accepts a
single project name. Use --list to cycle a specific set of projects in one
run, or 'camp fresh all' to cycle every project submodule in the campaign.

Without configuration, syncs to the default branch and prunes.
Configure .campaign/settings/fresh.yaml to set a default working branch.

Examples:
  camp fresh                            # Sync current project (checkout default, pull, prune)
  camp fresh --branch develop           # Sync and create develop branch
  camp fresh camp -b feat/new-thing     # Sync camp project, create feature branch
  camp fresh --list camp,fest,festival  # Sync a specific set of projects
  camp fresh --no-prune                 # Sync without pruning
  camp fresh --dry-run                  # Preview what would happen

```
camp fresh [project-name] [flags]
```

### Options

```
  -b, --branch string    Branch to create after syncing (overrides config)
  -n, --dry-run          Preview without making changes
  -h, --help             help for fresh
      --list strings     Comma-separated set of projects to cycle in one run
      --no-branch        Skip branch creation even if configured
      --no-prune         Skip pruning merged branches
      --no-push          Skip pushing the new branch upstream
  -p, --project string   Project name (auto-detected from cwd)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp fresh all](../camp_fresh_all/)	 - Run fresh across all project submodules
