---
title: "camp workitem adopt"
linkTitle: "camp workitem adopt"
description: "Attach .workitem metadata to an existing directory"
---

## camp workitem adopt

Attach .workitem metadata to an existing directory

### Synopsis

Attach workitem metadata to an existing campaign directory without moving it.

The target directory must already exist and must not already contain a
.workitem file. The command writes that .workitem metadata file with the
selected type, title, generated or supplied id, and optional quest link. Use
this when a workflow directory already exists and needs to become a tracked
workitem.

```
camp workitem adopt <dir> [flags]
```

### Options

```
  -h, --help           help for adopt
      --id string      override the generated id
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
