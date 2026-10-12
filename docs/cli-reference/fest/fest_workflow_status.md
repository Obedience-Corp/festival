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
that consumers can read without parsing the human-readable output. Each step in
the snapshot also carries the judge's followups, the complete recorded verdict
(finished at, confidence, evidence status), and the most recent hook runs the
festival ledger holds for that step.

Inside a standalone WORKFLOW.md directory, status reports that workflow's steps,
current step, completion, and blocked state from its .workflow/ run without
modifying it. The JSON snapshot then also carries workflow_doc, runtime_dir,
run_id, run_status, completed_steps, and blocked.

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
