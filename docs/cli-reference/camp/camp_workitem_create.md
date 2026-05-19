---
title: "camp workitem create"
linkTitle: "camp workitem create"
description: "Create a new workitem with v1 minimum metadata"
---

## camp workitem create

Create a new workitem with v1 minimum metadata

```
camp workitem create <slug> [flags]
```

### Options

```
      --dir string     parent dir override (default: workflow/<type>)
  -h, --help           help for create
      --id string      override the generated id
      --title string   human-readable title
      --type string    workitem type (feature, bug, chore, or custom) (default "feature")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
