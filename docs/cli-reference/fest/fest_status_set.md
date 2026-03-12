## fest status set

Change entity status

### Synopsis

Change the status of the current entity.

CONTEXT-AWARE BEHAVIOR:
When no explicit level flag is provided, the command auto-detects the
appropriate level based on your current directory:

  Festival root  → Sets festival status (planning/active/completed/dungeon)
  Phase directory → Sets phase status (pending/in_progress/completed)
  Sequence directory → Sets sequence status (pending/in_progress/completed)
  Task directory → Shows hint (task status requires explicit --task flag)

For festivals, this will move the directory between status folders.
If not inside a festival, an interactive selector will be shown.

EXPLICIT TARGETING:
Use flags to override auto-detection:
  --phase    Target a specific phase
  --sequence Target a specific sequence
  --task     Target a specific task
  --path     Target by explicit file path

These flags are mutually exclusive - only one level can be targeted at a time.

```
fest status set <status> [flags]
```

### Examples

```
  fest status set ready                # Set current festival to ready
  fest status set active               # Set current festival to active
  fest status set active -i            # Force interactive selection
  fest status set planning --force     # Override without prompts (e.g., backward transition)
  fest status set in_progress          # Set phase/sequence/task status

  # Level-specific status setting:
  fest status set --phase 001_CRITICAL completed
  fest status set --phase 001 in_progress
  fest status set --sequence 01_api_design completed
  fest status set --sequence 002/01 pending
  fest status set --task 01_analyze.md in_progress
  fest status set --task 001/01/02_impl.md completed
  fest status set --path ./002/01/task.md blocked
```

### Options

```
      --force             skip all prompts including non-standard transition warnings
  -h, --help              help for set
  -i, --interactive       force interactive festival selection
      --json              output in JSON format
      --no-commit         skip auto-commit after status change
      --path string       explicit file path for status change
      --phase string      target phase by name or number (e.g., '001_CRITICAL' or '001')
      --sequence string   target sequence by name (e.g., '01_api_design' or '002/01')
      --task string       target task by filename or path (e.g., '01_analyze.md' or '001/01/02_impl.md')
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest status](fest_status.md)	 - Manage and query festival entity statuses

