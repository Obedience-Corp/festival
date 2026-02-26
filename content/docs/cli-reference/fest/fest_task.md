## fest task

Manage task status (show, edit, complete, block, reset)

### Synopsis

Commands for managing individual task status within a festival.

These commands provide a simpler interface for viewing, editing, marking
tasks complete, blocked, or resetting them. Each mutation requires
interactive confirmation to ensure agents verify their work before proceeding.

Task Resolution:
  When [task] is omitted, the command auto-detects the current task:
    1. Finds the current in_progress task from the progress store
    2. Falls back to the next pending task (same logic as 'fest next')
    3. Errors if neither is found

  When [task] is provided, it resolves via:
    - Full relative path: 002_FOUNDATION/01_scaffold/01_design.md
    - Bare filename: 01_design.md (searches for unique match)

Examples:
  fest task show                          # Show current task details
  fest task show 01_design.md             # Show specific task
  fest task edit                          # Open current task in editor
  fest task completed                     # Mark current task complete (Y/n)
  fest task blocked --reason "need API"   # Mark task blocked (Y/n)
  fest task reset                         # Reset task to pending (Y/n)

### Options

```
  -h, --help   help for task
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
* [fest task blocked](fest_task_blocked.md)	 - Mark a task as blocked (requires confirmation)
* [fest task completed](fest_task_completed.md)	 - Mark a task as complete (requires confirmation)
* [fest task edit](fest_task_edit.md)	 - Open the current task in your editor
* [fest task reset](fest_task_reset.md)	 - Reset a task to pending (requires confirmation)
* [fest task show](fest_task_show.md)	 - Show task details and status

