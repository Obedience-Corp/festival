## camp project prune

Delete merged branches in a project

### Synopsis

Delete local branches that have been merged into the default branch.

Auto-detects the current project from your working directory,
or accepts a project name as a positional argument.

Protected branches (default branch, current branch) are never deleted.

Examples:
  camp project prune                     # Prune current project
  camp project prune camp                # Prune by name
  camp project prune -p camp             # Prune by flag
  camp project prune --dry-run           # Preview what would be deleted
  camp project prune --remote            # Also prune stale remote tracking refs
  camp project prune --remote-delete     # Also delete merged branches on origin

```
camp project prune [project-name] [flags]
```

### Options

```
  -n, --dry-run          Preview without deleting
  -f, --force            Skip local branch deletion confirmation
  -h, --help             help for prune
  -p, --project string   Project name (auto-detected from cwd)
      --remote           Also prune stale remote tracking refs
      --remote-delete    Also delete merged branches on origin (destructive)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects
* [camp project prune all](camp_project_prune_all.md)	 - Delete merged branches across all projects

