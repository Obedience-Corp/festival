---
title: "fest workflow approve"
linkTitle: "fest workflow approve"
description: "Approve a blocking checkpoint"
---

## fest workflow approve

Approve a blocking checkpoint

### Synopsis

Approve a blocking checkpoint and proceed to the next step.

Some workflow steps require explicit user approval before proceeding.
This is typically used for review gates or major decision points.

After approval:
  - The current step is marked as approved
  - The workflow advances to the next step

Auto approval:
  Manual approval is the default. Use --auto only when an operator has explicitly
  delegated this checkpoint decision to an external judge command.

  Agents must not clear checkpoints themselves: --as agent is rejected. An
  agent-actor decision is recorded only when the operator delegates via --auto
  and the judge returns a verdict.

  The judge command receives JSON on stdin using schema fest.approval.judge/v1
  and must return JSON on stdout with decision "approve" or "reject" and a
  reason. Missing commands, timeouts, non-zero exits, malformed JSON, unknown
  decisions, and empty reasons fail closed and do not approve the checkpoint.

  The judge command is resolved as: --judge-command flag, else the
  hooks.approval_judge.command hook in .festival/config.yaml. If neither is
  set, --auto fails closed and leaves the checkpoint unchanged.

      hooks:
        approval_judge:
          command: ob judge

```
fest workflow approve [flags]
```

### Options

```
      --auto                     delegate this checkpoint decision to the configured approval judge command
  -h, --help                     help for approve
      --judge-command string     approval judge command for --auto (overrides the .festival/config.yaml hooks.approval_judge.command hook)
      --judge-timeout duration   maximum time to wait for the approval judge (0 waits until it returns)
      --summary string           approval summary or rationale
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
