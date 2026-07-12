---
title: "fest create workflow"
linkTitle: "fest create workflow"
description: "Create a standalone or phase WORKFLOW.md from structured step definitions"
---

## fest create workflow

Create a standalone or phase WORKFLOW.md from structured step definitions

### Synopsis

Generate a parseable WORKFLOW.md from prompts, inline JSON, or a steps file.

Outside a festival phase, this creates WORKFLOW.md in the current directory,
initializes .workflow/ runtime state, and starts a tracked run so fest next works
immediately.

Inside a festival phase, or when --path/--festival targets a phase, this writes
the phase WORKFLOW.md without standalone runtime state.

Examples:
```bash
  # Standalone workflow in the current directory
  fest create workflow demo

  # Standalone workflow from inline JSON (for agents)
  fest create workflow demo --steps '{"title":"Review","steps":[...]}'

  # Phase workflow from a steps file
  fest create workflow --steps-file steps.json --position after

  # Explicit phase path
  fest create workflow --steps-file steps.json --path ./004_POLISH
```

```
fest create workflow [flags]
```

### Options

```
      --agent               Strict agent mode (implies --json)
      --festival string     Festival root override
  -h, --help                help for workflow
      --json                Emit JSON output
      --no-init             skip .workflow/ runtime init (advanced standalone mode)
      --path string         Phase directory path (festival mode) (default ".")
      --position string     Workflow position relative to sequences (before|after) (default "after")
      --steps string        Inline JSON with workflow definition
      --steps-file string   Path to JSON file with workflow definition
      --type string         workflow type (standalone mode only) (default "task")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest create](../fest_create/)	 - Create festivals, phases, sequences, or tasks (TUI)
