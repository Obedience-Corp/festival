---
title: "camp project remote rename"
linkTitle: "camp project remote rename"
description: "Rename a remote in the project"
---

## camp project remote rename

Rename a remote in the project

### Synopsis

Rename a git remote in the project repository.

Renaming away from "origin" is blocked by default for submodule projects
because submodule tracking depends on the "origin" remote name. A future
"git submodule sync" would recreate origin from .gitmodules, undoing the
rename and leaving the project in a confusing state.

Use --force to override this guard. If you need to change the URL instead,
use "camp project remote set-url".

Renaming TO "origin" is allowed and will update .gitmodules to use the
new remote's URL as the canonical submodule URL.

Examples:
  camp project remote rename upstream fork
  camp project remote rename origin old-origin --force

```
camp project remote rename <old> <new> [flags]
```

### Options

```
  -f, --force   Allow renaming away from origin (submodule tracking may break)
  -h, --help    help for rename
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
