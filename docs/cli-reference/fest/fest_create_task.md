---
title: "fest create task"
linkTitle: "fest create task"
description: "Insert a new task file in a sequence"
---

## fest create task

Insert a new task file in a sequence

### Synopsis

Create new task file(s) with automatic numbering and template rendering.

IMPORTANT: AI agents execute TASK FILES, not goals. If your sequences only
have SEQUENCE_GOAL.md without task files, agents won't know HOW to execute.

BATCH CREATION: Use multiple --name flags to create sequential tasks at once.
This avoids the common mistake of all tasks getting numbered 01_.

TEMPLATE VARIABLES (automatically set from --name):
  {{ task_name }}            Name of the task
  {{ task_number }}          Sequential number (01, 02, ...)
  {{ task_id }}              Full filename (e.g., "01_design.md")
  {{ parent_sequence_id }}   Parent sequence ID
  {{ parent_phase_id }}      Parent phase ID
  {{ full_path }}            Complete path from festival root

EXAMPLES:
```bash
  # Create single task in current sequence
  fest create task --name "design endpoints" --json

  # Create multiple tasks at once (sequential numbering)
  fest create task --name "requirements" --name "design" --name "implement"
  # Creates: 01_requirements.md, 02_design.md, 03_implement.md

  # Create tasks starting after position 2
  fest create task --after 2 --name "new step" --name "another step"
  # Creates: 03_new_step.md, 04_another_step.md

  # Create task in specific sequence
  fest create task --name "setup" --path ./002_IMPLEMENT/01_api --json
```

MARKER FILLING (for AI agents):
```bash
  # Fill all REPLACE markers in one command
  fest create task --name "setup" --markers '{"Brief description": "Auth middleware", "Yes/No": "Yes"}'

  # Preview template markers first (dry-run)
  fest create task --name "setup" --dry-run --json

  # Skip marker filling (leave REPLACE tags)
  fest create task --name "setup" --skip-markers
```

Run 'fest understand tasks' for detailed guidance on task file creation.
Run 'fest validate tasks' to verify task files exist in implementation sequences.

```
fest create task [flags]
```

### Options

```
      --after int             Insert after this number (0 inserts at beginning)
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --dry-run               Show template markers without creating file
  -h, --help                  help for task
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name strings          Task name(s) - can be specified multiple times for batch creation
      --path string           Path to sequence directory (directory containing numbered task files) (default ".")
      --skip-markers          Skip REPLACE marker processing
      --vars-file string      JSON vars for rendering
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest create](../fest_create/)	 - Create festivals, phases, sequences, or tasks (TUI)
