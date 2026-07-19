---
title: "camp workitem repair"
linkTitle: "camp workitem repair"
description: "Repair a workflow directory into a workitem"
---

## camp workitem repair

Repair a workflow directory into a workitem

### Synopsis

Repair a workflow directory so it carries a valid current-schema .workitem marker.

The directory is never moved or renamed and document contents are never touched.
When no marker exists one is created; when a legacy or incomplete marker exists
its schema version, kind, id, type, ref, and title are brought up to the current
shape. The workflow type is inferred from the path segment after workflow/, the
title from the first markdown H1 (else the humanized directory name), and id/ref
from the same rules as create and adopt. Repair is idempotent: a directory that
is already valid reports no changes. Use --dry-run to preview and --json for a
machine-readable result.

```
camp workitem repair <path> [flags]
```

### Options

```
      --dry-run       report what would change without writing
  -h, --help          help for repair
      --json          emit a structured JSON result
      --type string   override the workflow type inferred from the path
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
