## fest workflow

Manage workflow-based phase execution

### Synopsis

Commands for managing workflow-based phases (ingest, research, planning).

These phases use WORKFLOW.md files with step-by-step guidance and checkpoints.
Use 'fest next' to see the current step, then these commands to advance.

Workflow Steps:
  Workflows are defined in WORKFLOW.md files within phase directories.
  Each step has a goal, actions to complete, expected output, and an optional checkpoint.

Checkpoints:
  Some steps require user approval before proceeding. Use 'fest workflow approve'
  to approve or 'fest workflow reject' to request revisions.

State:
  Workflow progress is tracked in <festival>/.fest/progress_events.jsonl.
  Use 'fest workflow status' to view current progress.

Running from Festival Root:
  When run from the festival root (not inside a phase directory), the command
  will auto-detect the first incomplete workflow phase. Use --phase to specify
  a particular phase.

Examples:
  fest workflow status              # Show workflow progress
  fest workflow status --phase 001_INGEST  # Show specific phase
  fest workflow advance             # Complete current step and move to next
  fest workflow approve             # Approve a blocking checkpoint
  fest workflow reject              # Reject checkpoint with feedback
  fest workflow reset               # Reset workflow to step 1
  fest workflow show                # Display the current step details

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
* [fest workflow status](fest_workflow_status.md)	 - Show workflow progress

