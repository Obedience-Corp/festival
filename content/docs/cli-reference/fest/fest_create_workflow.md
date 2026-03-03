## fest create workflow

Create a WORKFLOW.md for a phase from structured step definitions

### Synopsis

Generate a WORKFLOW.md file for an existing phase directory.

Takes structured JSON input (inline or file) and produces a parseable WORKFLOW.md
that matches the format expected by the workflow parser.

Examples:
```bash
  # From a steps file
  fest create workflow --steps-file steps.json --position after

  # Inline JSON (for agents)
  fest create workflow --steps '{"title":"Review","steps":[...]}' --position before

  # With explicit phase path
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
      --path string         Phase directory path (default ".")
      --position string     Workflow position relative to sequences (before|after) (default "after")
      --steps string        Inline JSON with workflow definition
      --steps-file string   Path to JSON file with workflow definition
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest create](fest_create.md)	 - Create festivals, phases, sequences, or tasks (TUI)

