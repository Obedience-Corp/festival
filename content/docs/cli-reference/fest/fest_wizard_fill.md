## fest wizard fill

Interactively fill REPLACE markers in festival files

### Synopsis

Interactively fill [REPLACE: hint] markers in festival files.

This command scans for REPLACE markers in the specified file (or all .md files
in the directory) and provides multiple modes for filling them.

MODES:
  Interactive (TTY):  Opens files in configured editor for manual filling
  Batch Discovery:    Lists all markers as JSON (--list-markers)
  Batch Processing:   Applies JSON replacements in single pass (--batch-input)
  Sequential:         Text prompts for each marker (non-TTY stdin)

MARKER SYNTAX:
  [REPLACE: hint text]           Regular text input
  [REPLACE: Yes|No]              Select from options (pipe-separated)
  [REPLACE: Option A|Option B]   Multiple choice selection

EDITOR MODES (Interactive):
  buffer   Files loaded as buffers, navigate with :bn/:bp (default)
  tab      Each file in separate tab, navigate with gt/gT
  split    Vertical splits (previous default)
  hsplit   Horizontal splits

BATCH WORKFLOW (for agents):
  1. Discovery:  fest wizard fill --list-markers . > markers.json
  2. Edit markers.json to add "value" fields for each marker
  3. Apply:      fest wizard fill --batch-input markers.json

EXAMPLES:
  # Interactive with buffer mode (default)
  fest wizard fill .

  # Interactive with tabs
  fest wizard fill --editor-mode tab .

  # Custom editor flags
  fest wizard fill --editor-flags="-p" .

  # Batch workflow
  fest wizard fill --list-markers . > markers.json
  # ... edit markers.json to add values ...
  fest wizard fill --batch-input markers.json

  # Preview without writing changes
  fest wizard fill PHASE_GOAL.md --dry-run

  # Output results as JSON
  fest wizard fill PHASE_GOAL.md --json

The fill wizard transforms tedious manual editing into a guided experience,
ensuring all template markers are properly completed.

```
fest wizard fill [file-or-directory] [flags]
```

### Options

```
      --batch-input string     Batch JSON input file ('-' for stdin)
      --dry-run                Preview changes without writing
      --editor-flags strings   Custom editor flags (overrides mode)
      --editor-mode string     Editor window mode: buffer, tab, split, hsplit
  -h, --help                   help for fill
      --json                   Output results as JSON
      --list-markers           Output all markers as JSON for batch processing
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest wizard](fest_wizard.md)	 - Interactive guidance and assistance for festival creation

