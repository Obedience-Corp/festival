## camp project worktree add

Create a new worktree for the project

### Synopsis

Create a new git worktree for the current project.

Auto-detects the project from your current directory, or use --project
to specify explicitly.

The worktree will be created at: projects/worktrees/<project>/<name>/

By default, creates a new branch with the worktree name based on the current branch.
Use --branch to checkout an existing branch instead.

Examples:
  # Create worktree with new branch based on current branch (default)
  camp project worktree add feature-auth

  # Create worktree with new branch based on main
  camp project worktree add experiment --start-point main

  # Checkout existing branch (instead of creating new)
  camp project worktree add hotfix --branch hotfix-123

  # Track a remote branch
  camp project worktree add pr-review --track origin/feature-xyz

  # Explicit project
  camp project worktree add feature --project my-api

```
camp project worktree add <name> [flags]
```

### Options

```
  -b, --branch string        Checkout existing branch instead of creating new one
  -h, --help                 help for add
  -p, --project string       Project name (auto-detected from cwd if not specified)
  -s, --start-point string   Base branch/commit for new branch (default: current branch)
  -t, --track string         Remote branch to track (creates new local tracking branch)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project worktree](camp_project_worktree.md)	 - Manage worktrees for a project

