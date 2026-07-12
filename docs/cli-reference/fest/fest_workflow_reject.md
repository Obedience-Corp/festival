---
title: "fest workflow reject"
linkTitle: "fest workflow reject"
description: "Reject checkpoint with feedback"
---

## fest workflow reject

Reject checkpoint with feedback

### Synopsis

Reject a blocking checkpoint and provide feedback.

When a step's work doesn't meet requirements, use this command
to reject and request revisions.

The feedback will be recorded in the workflow state for reference.

Failed gates with remediation:
  Use --remediation-phase to record that a phase gate did not pass and
  to link a remediation phase that will correct the underlying issues.
  After the remediation phase completes, 'fest next' routes back to the
  failed gate for re-evaluation rather than treating it as approved.

Examples:
```bash
  fest workflow reject --reason "needs revision"
  fest workflow reject --reason "PR not ready" --remediation-phase 005_FIX_PR_302
  fest workflow reject --reason "missing acceptance proof" --summary "reviewed the diff against the task spec"
```

```
fest workflow reject [flags]
```

### Options

```
  -h, --help                       help for reject
  -r, --reason string              reason for rejection (required)
      --remediation-phase string   link a remediation phase for a failed gate (e.g. 005_FIX_PR_302)
      --summary string             decision summary or rationale
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
