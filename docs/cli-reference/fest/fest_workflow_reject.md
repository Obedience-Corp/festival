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

```
fest workflow reject [flags]
```

### Options

```
  -h, --help            help for reject
  -r, --reason string   reason for rejection (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest workflow](../fest_workflow/)	 - Manage workflow-based phase execution
