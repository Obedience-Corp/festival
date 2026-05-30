---
title: "camp workitem adopt"
linkTitle: "camp workitem adopt"
description: "Attach .workitem metadata to an existing directory"
---

## camp workitem adopt

Attach .workitem metadata to an existing directory

```
camp workitem adopt <dir> [flags]
```

### Options

```
  -h, --help           help for adopt
      --id string      override the generated id
      --quest string   capture quest_id from this quest (defaults to CAMP_QUEST env var if set)
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
