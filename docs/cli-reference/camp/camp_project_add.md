---
title: "camp project add"
linkTitle: "camp project add"
description: "Add a project to camp"
---

## camp project add

Add a project to camp

### Synopsis

Add a git repository as a project in the camp.

The project is cloned as a git submodule into the projects/ directory.
A worktree directory is also created for future parallel development.
The camp commit is always created so .gitmodules and the submodule pointer land together.

If you're already inside a camp, that camp is used by default.
Outside a camp, use --campaign <name-or-id> or a bare --campaign to
select a registered target camp.

Source can be:
  - SSH URL:   git@github.com:org/repo.git
  - HTTPS URL: https://github.com/org/repo.git
  - Local path (with --local): ./existing-repo

Examples:
  camp project add git@github.com:org/api.git           # Add remote repo
  camp project add https://github.com/org/web.git       # Add via HTTPS
  camp project add --local ./my-repo --name my-project  # Add existing local repo
  camp project add --campaign platform --local ./my-repo # Add outside current camp
  camp project add git@github.com:org/api.git --name backend  # Custom name

```
camp project add [source] [flags]
```

### Options

```
  -c, --campaign string   Target camp by name or ID; omit value to pick interactively
  -h, --help              help for add
  -l, --local string      Add existing local repository instead of cloning
  -n, --name string       Override project name (defaults to repo name)
  -p, --path string       Override destination path (defaults to projects/<name>)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
