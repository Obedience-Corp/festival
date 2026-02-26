## camp project

Manage campaign projects

### Synopsis

Manage git submodules and project repositories in the campaign.

A project is a git repository tracked as a submodule under the projects/ directory.
Projects can be added from remote URLs or existing local repositories.

Examples:
  camp project list                    List all projects
  camp project add git@github.com:org/repo.git  Add a new project
  camp project remove api-service      Remove a project

```
camp project [flags]
```

### Options

```
  -h, --help   help for project
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp project add](camp_project_add.md)	 - Add a project to campaign
* [camp project commit](camp_project_commit.md)	 - Commit changes in a project submodule
* [camp project list](camp_project_list.md)	 - List projects in campaign
* [camp project new](camp_project_new.md)	 - Create a new project in campaign
* [camp project remove](camp_project_remove.md)	 - Remove a project from campaign
* [camp project worktree](camp_project_worktree.md)	 - Manage worktrees for a project

