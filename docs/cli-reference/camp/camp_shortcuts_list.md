---
title: "camp shortcuts list"
linkTitle: "camp shortcuts list"
description: "List shortcuts for a specific project"
---

## camp shortcuts list

List shortcuts for a specific project

### Synopsis

List all sub-shortcuts configured for a specific project.

If no project is specified, lists all campaign shortcuts.

```
camp shortcuts list [project] [flags]
```

### Examples

```
  camp shortcuts list festival-methodology
  camp shortcuts list fest  # Fuzzy match
```

### Options

```
  -h, --help   help for list
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp shortcuts](../camp_shortcuts/)	 - List all available shortcuts
