## fest workflow

Manage workflow-based phase execution

### Synopsis

Commands for managing step-based phase navigation (workflows and phase gates).

These commands work with WORKFLOW.md files (step-by-step guidance for workflow phases)
and GATES.md files (phase-level quality gates for all phase types). Use 'fest next'
to see the current step, then these commands to advance.

Workflow Steps:
  Workflows are defined in WORKFLOW.md files within phase directories.
  Each step has a goal, actions to complete, expected output, and an optional checkpoint.

Phase Gates:
  Gates are defined in GATES.md files and run after all other phase work is complete.
  Each gate step poses a quality/compliance question requiring approval before the
  phase can advance. Gates are available for all phase types.

Checkpoints:
  Some steps require user approval before proceeding. Use 'fest workflow approve'
  to approve or 'fest workflow reject' to request revisions.

State:
  Progress is tracked in <festival>/.fest/progress_events.jsonl.
  Use 'fest workflow status' to view current progress.

Running from Festival Root:
  When run from the festival root (not inside a phase directory), the command
  auto-detects the first incomplete navigable phase (workflow or gate).
  Use --phase to specify a particular phase.

Auto-Routing:
  Commands automatically target the correct document:
  - WORKFLOW.md if incomplete (takes priority)
  - GATES.md if workflow is complete/absent and phase work is done

Examples:
```bash
  fest workflow status              # Show workflow or gate progress
  fest workflow status --phase 001_INGEST  # Show specific phase
  fest workflow advance             # Complete current step and move to next
  fest workflow skip --reason "already completed externally" # Operator override
  fest workflow approve             # Approve a blocking checkpoint
  fest workflow reject              # Reject checkpoint with feedback
  fest workflow reset               # Reset workflow or gate to step 1
  fest workflow show                # Display the current step details
```

### Options

```
  -h, --help           help for workflow
      --phase string   specify phase directory (e.g., 001_INGEST)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest workflow advance](fest_workflow_advance.md)	 - Complete current step and move to next
* [fest workflow approve](fest_workflow_approve.md)	 - Approve a blocking checkpoint
* [fest workflow reject](fest_workflow_reject.md)	 - Reject checkpoint with feedback
* [fest workflow reset](fest_workflow_reset.md)	 - Reset workflow to step 1
* [fest workflow show](fest_workflow_show.md)	 - Display current step details
* [fest workflow skip](fest_workflow_skip.md)	 - Operator override: mark workflow steps as skipped/completed
* [fest workflow status](fest_workflow_status.md)	 - Show workflow progress

