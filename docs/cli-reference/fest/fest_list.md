---
title: "fest list"
linkTitle: "fest list"
description: "List festivals by status"
---

## fest list

List festivals by status

### Synopsis

List festivals filtered by status.

Works from anywhere - finds the festivals workspace automatically.

STATUS can be: active, ready, planning, ritual, completed, all,
dungeon, dungeon/completed, dungeon/archived, dungeon/someday

By default, shows active, ready, planning, and ritual festivals.
Use 'fest list all' (or --all) to include completed and dungeon festivals.

Use --watch to continuously refresh the multi-festival status board in place
(similar to fest watch, but without cycling between festivals). Ctrl+C to quit.

```
fest list [status] [flags]
```

### Examples

```
  fest list                                        # Active, ready, planning, ritual festivals
  fest list active                                 # Only active festivals
  fest list all                                    # Every festival grouped by status
  fest list dungeon/completed                      # Completed festivals in the dungeon
  fest list --filter-project camp                  # Festivals linked to "camp" project
  fest list active --sort progress                 # Active festivals, most complete first
  fest list --since 2026-01-01 --until 2026-02-01  # Created in January 2026
  fest list --json                                 # Output in JSON format
  fest list --watch                                # Live multi-festival status board
  fest list active --watch                         # Watch only active festivals
```

### Options

```
      --all                     include completed and dungeon festivals
      --alpha                   sort alphabetically by name instead of by date
      --filter-project string   filter festivals linked to a project path (substring match)
  -h, --help                    help for list
      --json                    output in JSON format
      --progress                show detailed progress for each festival
      --since string            show festivals created on or after this date (YYYY-MM-DD or RFC3339)
      --sort string             sort by: date|status|progress|name|created|updated
      --status string           filter by status: active|planning|completed|dungeon
      --until string            show festivals created on or before this date (YYYY-MM-DD or RFC3339)
  -w, --watch                   continuously refresh the list in place until Ctrl+C
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
