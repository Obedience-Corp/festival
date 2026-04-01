---
title: "camp project remote remove"
linkTitle: "camp project remote remove"
description: "Remove a remote from the project"
---

## camp project remote remove

Remove a remote from the project

### Synopsis

Remove a git remote from the project repository.

Removing the "origin" remote is blocked by default because it is the
canonical remote for submodule tracking. Use --force to override.

When --force is used to remove origin from a submodule project, the
.gitmodules entry is also cleaned up to keep the campaign consistent.

Note: if you want to change the canonical URL instead of removing it,
use "camp project remote set-url".

Examples:
  camp project remote remove upstream
  camp project remote remove origin --force   # also cleans .gitmodules

```
camp project remote remove <name> [flags]
```

### Options

```
  -f, --force   Allow removing the origin remote (dangerous)
  -h, --help    help for remove
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
