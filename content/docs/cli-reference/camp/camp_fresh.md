## camp fresh

Post-merge branch cycling: sync to default branch and optionally create a new working branch

### Synopsis

Reset a project to a fresh state after merging a PR.

Performs the post-merge cycle: checkout default branch, pull latest,
prune merged branches, and optionally create a new working branch.

Auto-detects the current project from your working directory,
or accepts a project name as a positional argument.

Without configuration, syncs to the default branch and prunes.
Configure .campaign/settings/fresh.yaml to set a default working branch.

Examples:
  camp fresh                         # Sync current project (checkout default, pull, prune)
  camp fresh --branch develop        # Sync and create develop branch
  camp fresh camp -b feat/new-thing  # Sync camp project, create feature branch
  camp fresh --no-prune              # Sync without pruning
  camp fresh --dry-run               # Preview what would happen

```
camp fresh [project-name] [flags]
```

### Options

```
  -b, --branch string    Branch to create after syncing (overrides config)
  -n, --dry-run          Preview without making changes
  -h, --help             help for fresh
      --no-branch        Skip branch creation even if configured
      --no-prune         Skip pruning merged branches
      --no-push          Skip pushing the new branch upstream
  -p, --project string   Project name (auto-detected from cwd)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp fresh all](camp_fresh_all.md)	 - Run fresh across all project submodules

