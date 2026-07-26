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
  Configuring hooks.definitions.approval_judge is the operator opt-in that
  delegates blocking checkpoints away from human review. With that hook set,
```bash
  fest next auto-invokes the judge on blocking WORKFLOW.md / GATES.md steps.

  Use 'fest workflow judge' to re-run the judge explicitly after a rejection;
  '--auto' remains a backwards-compatible alias. Agents must not clear checkpoints with --as agent;
  agent-actor decisions are recorded only via the judge path.

  Checkpoint classes:
    artifact_review         — deliverables can be auto-judged when evidence is ready
    operator_attestation    — human must approve; --auto is refused and plain
                              manual approval requires an interactive TTY

  Presentation-like steps require non-empty evidence (e.g. output_specs/PRESENTATION.md)
  before the judge is invoked. Missing evidence blocks deterministically without a model call.

  After a judge reject, re-submit with: fest workflow judge
  Operator override: run --override-judge --summary "..." from a real terminal
  and type APPROVE when prompted; records decision_actor=user_override.

  When an approval judge is configured, non-interactive manual approve is
  refused, including --override-judge and --judge-command, so agents cannot
  mint decision_actor=user or user_override. Use a real terminal and type
  APPROVE.

  The judge command receives JSON on stdin using schema fest.approval.judge/v1
  and must return JSON on stdout with decision "approve" or "reject" and a
  reason. Missing commands, timeouts, non-zero exits, malformed JSON, unknown
  decisions, and empty reasons fail closed and do not approve the checkpoint.

  The judge command is resolved as: --judge-command flag, else the
  hooks.definitions.approval_judge hook in .festival/config.yaml. If neither is
  set, --auto fails closed and leaves the checkpoint unchanged.

      hooks:
        definitions:
          approval_judge:
            command: ob judge
            timeout: 0

  By default --auto launches the judge in the background and returns
  immediately; the checkpoint stays blocked until the verdict lands, and
  'fest show' renders the waiting-on-judge state while it runs. Use --wait
  to block until the judge returns instead.
```

```
fest workflow approve [flags]
```

### Options

```
      --auto                     delegate this checkpoint decision to the configured approval judge command
  -h, --help                     help for approve
      --judge-command string     approval judge command for --auto (overrides the .festival/config.yaml hooks.definitions.approval_judge hook; requires an interactive TTY)
      --judge-timeout duration   maximum time to wait for the approval judge (0 waits until it returns)
      --override-judge           operator override of a judge/readiness reject (requires --summary and an interactive TTY)
      --summary string           approval summary or rationale (required with --override-judge)
      --wait                     block until the judge returns instead of launching it in the background
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
