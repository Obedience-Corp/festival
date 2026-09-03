---
title: "camp project stage"
linkTitle: "camp project stage"
description: "Stage changes in a project submodule"
---

## camp project stage

Stage changes in a project submodule

### Synopsis

Stage changes within a project submodule without committing.

Runs the same auto-staging logic as 'camp project commit' (including
stale lock file cleanup) but stops before creating a commit, so you can
use a different commit strategy.

Auto-detects the current project from your working directory,
or use --project to specify a project by name.

Examples:
  # From within a project directory
  cd projects/my-api
  camp project stage

  # Specify project by name
  camp project stage --project my-api

```
camp project stage [flags]
```

### Options

```
  -h, --help             help for stage
  -p, --project string   Project name (auto-detected from cwd if not specified)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
