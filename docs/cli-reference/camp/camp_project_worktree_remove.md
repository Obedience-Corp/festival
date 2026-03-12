## camp project worktree remove

Remove a worktree

### Synopsis

Remove a worktree from the current project.

Auto-detects the project from your current directory, or use --project
to specify explicitly.

Examples:
  # From within a project
  cd projects/my-api
  camp project worktree remove feature-auth

  # Force remove (even with uncommitted changes)
  camp project worktree remove experiment --force

  # Explicit project
  camp project worktree remove feature --project my-api

```
camp project worktree remove <name> [flags]
```

### Options

```
  -f, --force            Force removal even with uncommitted changes
  -h, --help             help for remove
  -p, --project string   Project name (auto-detected from cwd if not specified)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project worktree](camp_project_worktree.md)	 - Manage worktrees for a project

