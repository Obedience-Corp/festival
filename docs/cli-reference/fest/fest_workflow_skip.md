---
title: "fest workflow skip"
linkTitle: "fest workflow skip"
description: "Operator override: mark workflow steps as skipped/completed"
---

## fest workflow skip

Operator override: mark workflow steps as skipped/completed

### Synopsis

Mark remaining steps in a workflow phase with an explicit terminal state.

Use this when work was already completed outside the normal fest next loop and
you need a documented operator override with an audit reason.
Example: backfilling earlier phases for ai-investor-outreach-system-AI0001.

Security:
  - Human operator only (excluded from agent manifest access)
  - Requires an interactive TTY
  - Requires --reason for auditability

```
fest workflow skip [flags]
```

### Options

```
      --as string       terminal state to apply: skipped or completed (default "skipped")
  -h, --help            help for skip
  -r, --reason string   human-readable reason for operator override (required)
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
