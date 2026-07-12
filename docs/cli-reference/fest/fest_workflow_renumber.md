---
title: "fest workflow renumber"
linkTitle: "fest workflow renumber"
description: "Renumber step headings in a WORKFLOW.md to a contiguous 1-indexed sequence"
---

## fest workflow renumber

Renumber step headings in a WORKFLOW.md to a contiguous 1-indexed sequence

### Synopsis

Renumber the "## Step N:" headings inside a WORKFLOW.md so they form a
contiguous 1-indexed sequence (Step 1, Step 2, ..., Step K) in document order.

Only the heading lines are touched. Step body text, the Workflow State Tracking
table, and any other markdown content are left exactly as written.

The default target is ./WORKFLOW.md. Pass an explicit path to target another file.

Like other renumber commands, --dry-run is the default so you can preview the
plan; pass --skip-dry-run to write changes immediately.

Known v1 limitations:
  - Cross-references inside step bodies (for example "see Step 3") are not
    rewritten. Update those references by hand after renumbering if needed.

Examples:
```bash
  fest workflow renumber                              # preview ./WORKFLOW.md
  fest workflow renumber ./phases/001_PLAN/WORKFLOW.md
  fest workflow renumber --skip-dry-run               # apply changes
  fest workflow renumber --skip-dry-run --backup      # write .bak alongside
```

```
fest workflow renumber [path] [flags]
```

### Options

```
      --backup         write a .bak copy of the original before applying
      --dry-run        preview changes without writing (default true)
  -h, --help           help for renumber
      --skip-dry-run   skip preview and apply changes immediately
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest workflow](../fest_workflow/)	 - Manage workflow-based phase execution
