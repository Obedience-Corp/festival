---
title: "camp project remote"
linkTitle: "camp project remote"
description: "Manage remotes for a project"
---

## camp project remote

Manage remotes for a project

### Synopsis

Manage git remotes for a campaign project.

Auto-detects the current project from your working directory, or use --project
to specify explicitly.

Commands:
  list      List remotes (default)
  set-url   Update a remote URL atomically across all locations
  add       Add a new remote
  remove    Remove a remote
  rename    Rename a remote

Examples:
  # From within a project directory
  cd projects/my-api
  camp project remote                          # List remotes
  camp project remote set-url git@github.com:org/new-repo.git
  camp project remote add upstream git@github.com:org/upstream.git
  camp project remote remove upstream
  camp project remote rename upstream fork

  # With explicit project
  camp project remote list --project my-api

```
camp project remote [flags]
```

### Options

```
  -h, --help             help for remote
  -p, --project string   Project name (auto-detected from cwd if not specified)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage campaign projects
* [camp project remote add](../camp_project_remote_add/)	 - Add a new remote to the project
* [camp project remote list](../camp_project_remote_list/)	 - List remotes for the project
* [camp project remote remove](../camp_project_remote_remove/)	 - Remove a remote from the project
* [camp project remote rename](../camp_project_remote_rename/)	 - Rename a remote in the project
* [camp project remote set-url](../camp_project_remote_set-url/)	 - Update a remote URL for the project
