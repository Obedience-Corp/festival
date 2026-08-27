---
title: "camp workitem completion"
linkTitle: "camp workitem completion"
description: "Set completed-run review behavior for a workitem"
---

## camp workitem completion

Set completed-run review behavior for a workitem

### Synopsis

Set how completed standalone workflow runs affect one workitem.

review restores the default and clears any one-run acknowledgement.
acknowledge keeps the workitem active and suppresses only its latest completed
run. recurring keeps the workitem active and suppresses every completed-run
review until review is restored. Persistent decisions live in the versioned
.workitem marker and apply to both camp fresh and camp workitem sweep.

```
camp workitem completion <selector> <review|acknowledge|recurring> [flags]
```

### Options

```
  -h, --help   help for completion
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
