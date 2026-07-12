---
title: "fest workflow validate"
linkTitle: "fest workflow validate"
description: "Validate WORKFLOW.md step numbering"
---

## fest workflow validate

Validate WORKFLOW.md step numbering

### Synopsis

Validate a standalone WORKFLOW.md file for correct step numbering.

Step headings ('## Step N:') must start at 1 and form a contiguous sequence
with no gaps or duplicates. No other checks are performed (section names,
state-tracking tables, and checkpoint syntax are deliberately not validated).

If no path is provided, defaults to ./WORKFLOW.md in the current directory.

```
fest workflow validate [path] [flags]
```

### Options

```
  -h, --help   help for validate
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
