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

STATUS can be: active, planning, completed, dungeon, dungeon/completed, dungeon/archived, dungeon/someday

By default, shows only active and planning festivals.
Use --all to include completed and dungeon festivals.

```
fest list [status] [flags]
```

### Examples

```
  fest list                                       # List active and planning festivals
  fest list --all                                  # List all festivals
  fest list --filter-project camp                  # Festivals linked to "camp" project
  fest list --since 2026-01-01                     # Festivals created since Jan 1
  fest list --since 2026-01-01 --until 2026-02-01  # Created in January 2026
  fest list --filter-project fest --status active   # Active festivals for "fest" project
  fest list --json                                 # Output in JSON format
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
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
