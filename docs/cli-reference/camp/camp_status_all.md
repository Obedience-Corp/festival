---
title: "camp status all"
linkTitle: "camp status all"
description: "Show git status of all submodules"
---

## camp status all

Show git status of all submodules

### Synopsis

Show a visual overview of git status for all submodules in the camp.

Displays a table with each submodule's name, branch, clean/dirty state,
and push status.

Examples:
  camp status all               # Show all submodule statuses
  camp status all --remote-url  # Show remote URLs instead of names
  camp status all --json        # Output as JSON

```
camp status all [flags]
```

### Options

```
  -h, --help         help for all
      --json         Output as JSON
      --no-recurse   Only list top-level submodules
      --remote-url   Show remote URLs instead of remote names
      --view         Open interactive TUI viewer
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp status](../camp_status/)	 - Show git status of the camp
