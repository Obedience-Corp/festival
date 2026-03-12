## camp project prune all

Delete merged branches across all projects

### Synopsis

Delete local branches that have been merged into the default branch,
across every project submodule in the campaign.

Produces a per-project summary showing what was (or would be) pruned.

Examples:
  camp project prune all                 # Prune all projects
  camp project prune all --dry-run       # Preview across all projects
  camp project prune all --force         # Skip confirmation for each project
  camp project prune all --remote        # Also prune stale remote tracking refs

```
camp project prune all [flags]
```

### Options

```
  -h, --help   help for all
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project prune](camp_project_prune.md)	 - Delete merged branches in a project

