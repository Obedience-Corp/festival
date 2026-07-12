---
title: "fest workflow status"
linkTitle: "fest workflow status"
description: "Show workflow progress"
---

## fest workflow status

Show workflow progress

### Synopsis

Display the current progress of the workflow in this phase.

Shows:
  - Current step number and name
  - Completed steps
  - Remaining steps
  - Checkpoint status if applicable

Use --json for a stable machine-readable snapshot (schema fest.workflow.status/v1)
that consumers can read without parsing the human-readable output.

```
fest workflow status [flags]
```

### Options

```
  -h, --help   help for status
      --json   output as JSON
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
