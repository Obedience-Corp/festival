## camp project worktree

Manage worktrees for a project

### Synopsis

Manage git worktrees for the current project.

Worktrees allow you to have multiple working directories for the same repository,
enabling parallel development on different branches without stashing or switching.

Auto-detects the current project from your working directory, or use --project
to specify explicitly.

All worktrees are created at: projects/worktrees/<project>/<worktree-name>/

Commands:
  add       Create a new worktree
  list      List worktrees for the project
  remove    Remove a worktree

Examples:
  # From within a project directory
  cd projects/my-api
  camp project worktree add feature-auth      # Creates new branch based on current
  camp project worktree add fix --start-point main  # New branch based on main
  camp project worktree list
  camp project worktree remove feature-auth

  # With explicit project
  camp project worktree add feature-xyz --project my-api

```
camp project worktree [flags]
```

### Options

```
  -h, --help   help for worktree
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects
* [camp project worktree add](camp_project_worktree_add.md)	 - Create a new worktree for the project
* [camp project worktree list](camp_project_worktree_list.md)	 - List worktrees for the project
* [camp project worktree remove](camp_project_worktree_remove.md)	 - Remove a worktree

