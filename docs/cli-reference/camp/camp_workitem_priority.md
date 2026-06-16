---
title: "camp workitem priority"
linkTitle: "camp workitem priority"
description: "Set or clear the manual priority of a workitem"
---

## camp workitem priority

Set or clear the manual priority of a workitem

### Synopsis

Set or clear the manual priority of a workitem.

The selector accepts the same forms as 'camp workitem current': a stable
.workitem id, the workitem key (<type>:<path>), a relative path, or a directory
slug. Priority is one of high, medium, low, or clear (clear removes any manual
priority). Assignments persist in .campaign/settings/workitems.json, the same
store the interactive dashboard writes.

Examples:
  camp workitem priority festival:festivals/active/demo high
  camp workitem priority demo clear
  camp workitem priority demo high --json

```
camp workitem priority <selector> <high|medium|low|clear> [flags]
```

### Options

```
  -h, --help   help for priority
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
