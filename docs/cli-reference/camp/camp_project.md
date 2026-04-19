---
title: "camp project"
linkTitle: "camp project"
description: "Manage campaign projects"
---

## camp project

Manage campaign projects

### Synopsis

Manage git submodules and project repositories in the campaign.

A project can be:
  - a git repository tracked as a submodule under projects/
  - a machine-local linked workspace attached via symlink under projects/

Use 'camp project add' for submodules and 'camp project link' / 'camp project unlink'
for linked workspaces.

Examples:
  camp project list                    List all projects
  camp project add git@github.com:org/repo.git  Add a new project
  camp project link ~/code/my-project  Link an existing local workspace
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
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp project add](../camp_project_add/)	 - Add a project to campaign
* [camp project commit](../camp_project_commit/)	 - Commit changes in a project submodule
* [camp project link](../camp_project_link/)	 - Link an existing local project into a campaign
* [camp project list](../camp_project_list/)	 - List projects in campaign
* [camp project new](../camp_project_new/)	 - Create a new project in campaign
* [camp project prune](../camp_project_prune/)	 - Delete merged branches in a project
* [camp project remote](../camp_project_remote/)	 - Manage remotes for a project
* [camp project remove](../camp_project_remove/)	 - Remove a project from campaign
* [camp project run](../camp_project_run/)	 - Run a command inside a project directory
* [camp project unlink](../camp_project_unlink/)	 - Unlink a linked project from a campaign
* [camp project worktree](../camp_project_worktree/)	 - Manage worktrees for a project
