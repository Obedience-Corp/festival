---
title: "fest search"
linkTitle: "fest search"
description: "Search festivals by name, ID, or goal text"
---

## fest search

Search festivals by name, ID, or goal text

### Synopsis

Search across all festivals in the workspace using fuzzy matching.

Matches against:
  - Festival directory names
  - Festival IDs (from frontmatter)
  - Goal text (from FESTIVAL_OVERVIEW.md)

Results are ranked by relevance with exact and prefix matches scored highest.

```
fest search <query> [flags]
```

### Examples

```
  fest search intents           # Find festivals matching "intents"
  fest search --status active   # Search only active festivals
  fest search RI0001            # Search by festival ID
  fest search --json deploy     # JSON output for scripting
```

### Options

```
  -h, --help            help for search
      --json            output results as JSON
      --limit int       maximum number of results (default 20)
      --status string   limit search to status: active|planning|completed|dungeon
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
