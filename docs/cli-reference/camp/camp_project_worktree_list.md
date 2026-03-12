## camp project worktree list

List worktrees for the project

### Synopsis

List all worktrees for the current project.

Auto-detects the project from your current directory, or use --project
to specify explicitly.

Examples:
  # From within a project
  cd projects/my-api
  camp project worktree list

  # Explicit project
  camp project worktree list --project my-api

```
camp project worktree list [flags]
```

### Options

```
  -h, --help             help for list
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

