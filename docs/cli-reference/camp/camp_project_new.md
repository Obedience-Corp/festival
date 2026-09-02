---
title: "camp project new"
linkTitle: "camp project new"
description: "Create a new project in camp"
---

## camp project new

Create a new project in camp

### Synopsis

Create a new local project as a git submodule in the camp.

The project is initialized as a git repository with an initial commit,
then added as a submodule under projects/. No remote repository is required.
The camp commit is always created so .gitmodules and the submodule pointer land together.

You can add a remote later:
  cd projects/<name>
  git remote add origin git@github.com:org/<name>.git

Examples:
  camp project new my-service             # Create new project

```
camp project new <name> [flags]
```

### Options

```
  -h, --help          help for new
  -p, --path string   Override destination path (defaults to projects/<name>)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
