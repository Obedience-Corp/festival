## fest create sequence

Insert a new sequence and render its goal file

### Synopsis

Create a new sequence directory with SEQUENCE_GOAL.md.

IMPORTANT: After creating a sequence, you must also create TASK FILES.
The SEQUENCE_GOAL.md defines WHAT to achieve, but AI agents need task
files to know HOW to execute. See 'fest understand tasks'.

TEMPLATE VARIABLES (automatically set):
  {{ sequence_name }}        Name of the sequence
  {{ sequence_number }}      Sequential number (01, 02, ...)
  {{ sequence_id }}          Full ID (e.g., "01_api_endpoints")
  {{ parent_phase_id }}      Parent phase ID

EXAMPLES:
```bash
  # Create sequence in current phase
  fest create sequence --name "api endpoints" --json

  # Create sequence at specific position
  fest create sequence --name "frontend" --after 2 --json
```

NEXT STEPS after creating a sequence:
```bash
  # Add task files (required for implementation sequences)
  fest create task --name "design" --json
  fest create task --name "implement" --json

  # Add quality gates
  fest gates apply --approve
```

Run 'fest validate tasks' to verify task files exist.

```
fest create sequence [flags]
```

### Options

```
      --after int             Insert after this sequence number (-1 or omit to append at end) (default -1)
      --agent                 Strict mode: require markers, auto-validate, block on errors, JSON output
      --dry-run               Show template markers without creating file
      --festival string       Path to festival directory (use when not inside a festival)
  -h, --help                  help for sequence
      --json                  Emit JSON output
      --markers string        JSON string with REPLACE marker hint→value mappings
      --markers-file string   JSON file with REPLACE marker hint→value mappings
      --name string           Sequence name (required)
      --no-prompt             Skip interactive prompts
      --path string           Path to phase directory (directory containing numbered sequences) (default ".")
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

* [fest create](fest_create.md)	 - Create festivals, phases, sequences, or tasks (TUI)

