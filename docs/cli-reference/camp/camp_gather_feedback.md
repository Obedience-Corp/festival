## camp gather feedback

Gather feedback observations from festivals into intents

### Synopsis

Scan festival directories for feedback observations and create
trackable FEEDBACK intent files with checkboxes.

Each festival with feedback observations gets a FEEDBACK_<fest_id>.md intent
in workflow/intents/inbox/. Observations are grouped by criteria with
checkboxes for tracking addressed status.

Deduplication tracking ensures observations are only gathered once.
Re-running the command appends only new observations to existing intents,
preserving any checkbox state from previous runs.

Examples:
  # Gather all feedback from all festivals
  camp gather feedback

  # Preview what would be gathered
  camp gather feedback --dry-run

  # Gather from a specific festival
  camp gather feedback --festival-id CC0004

  # Only gather from completed festivals
  camp gather feedback --status completed

  # Filter by severity
  camp gather feedback --severity high

  # Re-gather everything (ignore tracking)
  camp gather feedback --force

```
camp gather feedback [flags]
```

### Options

```
      --dry-run              Preview without creating intents
      --festival-id string   Only gather from a specific festival
      --force                Re-gather all, ignoring tracking
  -h, --help                 help for feedback
      --no-commit            Skip git commit
      --severity string      Filter by observation severity (low, medium, high)
      --status string        Festival status dirs to scan (comma-separated) (default "completed,active,planned")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp gather](camp_gather.md)	 - Import external data into the intent system

