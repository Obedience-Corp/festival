---
title: "camp workitem current"
linkTitle: "camp workitem current"
description: "Get, set, or clear the local current workitem"
---

## camp workitem current

Get, set, or clear the local current workitem

### Synopsis

Get, set, or clear the campaign-local current workitem pointer.

The selection is stored in .campaign/workitems/current.yaml and is used by
commands that need a default workitem when cwd alone is ambiguous. Pass a
selector to set the current workitem, omit it to read the selection, or use
--clear to remove it. Use --json for machine-readable current selection output.

```
camp workitem current [selector] [flags]
```

### Options

```
      --clear   remove the local current.yaml selection
  -h, --help    help for current
      --json    emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
