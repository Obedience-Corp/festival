---
title: "camp workitem resolve"
linkTitle: "camp workitem resolve"
description: "Print the workitem for the current context"
---

## camp workitem resolve

Print the workitem for the current context

### Synopsis

Resolve the active workitem from the current campaign context.

Resolution checks explicit selectors, cwd, festival context, linked scopes,
and the current-workitem file without mutating any files. Use --explain to show
the tier-by-tier trace used to choose the result. Use --json for
machine-readable resolution details and trace data.

```
camp workitem resolve [flags]
```

### Options

```
      --explain           print the tier-by-tier resolution trace
      --festival string   festival id for the festival tier
  -h, --help              help for resolve
      --json              emit a structured JSON result
      --workitem string   explicit workitem selector (overrides cwd-based detection)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
