---
title: "camp project remote set-url"
linkTitle: "camp project remote set-url"
description: "Update a remote URL for the project"
---

## camp project remote set-url

Update a remote URL for the project

### Synopsis

Update a remote URL across all tracked locations with automatic rollback.

For submodule projects, updates three locations in order:
  1. .gitmodules  (canonical, tracked in git)
  2. local git submodule config (.git/config of the campaign root)
  3. remote config inside the project repo

If any step fails, previous steps are automatically rolled back to keep
all locations consistent. If rollback also fails, recovery instructions
are printed so you can fix it manually.

For non-submodule projects, only the remote config is updated.

Flags:
  --name      Remote name to update (default: origin)
  --no-verify Skip connectivity check after updating
  --no-stage  Skip auto-staging .gitmodules

Examples:
  camp project remote set-url git@github.com:org/new-name.git
  camp project remote set-url https://github.com/org/repo.git --name upstream
  camp project remote set-url git@github.com:org/repo.git --no-verify

```
camp project remote set-url <url> [flags]
```

### Options

```
  -h, --help          help for set-url
  -n, --name string   Remote name to update (default "origin")
      --no-stage      Skip auto-staging .gitmodules
      --no-verify     Skip connectivity check after updating
```

### Options inherited from parent commands

```
      --config string    config file (default: ~/.obey/campaign/config.json)
      --no-color         disable colored output
  -p, --project string   Project name (auto-detected from cwd if not specified)
      --verbose          enable verbose output
```

### SEE ALSO

* [camp project remote](../camp_project_remote/)	 - Manage remotes for a project
