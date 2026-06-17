---
title: "camp workflow list"
linkTitle: "camp workflow list"
description: "List user-created workflow collections"
---

## camp workflow list

List user-created workflow collections

### Synopsis

List user-created workflow collections registered in the campaign.

The command reads campaign configuration and workflow/ directories, then shows
each collection's shortcut, item count, and latest workitem update. Built-in
workflow types are omitted so the output focuses on custom collections. Use
--json for machine-readable workflow inventory output.

```
camp workflow list [flags]
```

### Options

```
  -h, --help   help for list
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workflow](../camp_workflow/)	 - Manage workflow collections
