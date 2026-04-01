---
title: "camp project remote add"
linkTitle: "camp project remote add"
description: "Add a new remote to the project"
---

## camp project remote add

Add a new remote to the project

### Synopsis

Add a new git remote to the project repository.

This does NOT modify .gitmodules — use set-url to change the canonical
origin for a submodule. Use this command to add secondary remotes such
as an upstream fork or a mirror.

After adding, a git fetch is performed to verify connectivity and
report how many refs are available.

Examples:
  camp project remote add upstream git@github.com:org/upstream.git
  camp project remote add mirror https://gitlab.com/org/repo.git

```
camp project remote add <name> <url> [flags]
```

### Options

```
  -h, --help   help for add
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
