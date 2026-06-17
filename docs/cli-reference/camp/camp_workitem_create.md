---
title: "camp workitem create"
linkTitle: "camp workitem create"
description: "Create a new workitem with v1 minimum metadata"
---

## camp workitem create

Create a new workitem with v1 minimum metadata

### Synopsis

Create a new workitem directory with minimal v1 metadata.

The workitem is created under workflow/<type>/<slug>/ unless --dir supplies a
different campaign-relative parent directory. A .workitem file is written with
the id, type, title, ref, creation metadata, and optional quest link. Use --json
for machine-readable output containing the new workitem identity and next-step
location.

```
camp workitem create <slug> [flags]
```

### Options

```
      --dir string     parent dir override (default: workflow/<type>)
  -h, --help           help for create
      --id string      override the generated id
      --json           emit a structured JSON result
      --quest string   quest ID to associate (requires dev-profile camp; forward-compatible flag)
      --title string   human-readable title
      --type string    workitem type (feature, bug, chore, or custom) (default "feature")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
