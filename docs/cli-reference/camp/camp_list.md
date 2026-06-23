---
title: "camp list"
linkTitle: "camp list"
description: "List all registered campaigns"
---

## camp list

List all registered campaigns

### Synopsis

List all campaigns registered in the global registry.

Campaigns are registered when created with 'camp init' or manually
with 'camp register'. The registry lives at ~/.obey/campaign/registry.json.

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Campaign names only, one per line
  json    - JSON array for scripting

Sorting options:
  accessed - Most recently accessed first (default)
  name     - Alphabetically by name
  type     - Alphabetically by type

Examples:
  camp list                  List all campaigns
  camp list --json           Output as JSON
  camp list --format json    Output as JSON
  camp list --sort name      Sort by name
  camp list --format simple  Names only for scripting
  camp list --count          Print only the total number of campaigns

```
camp list [flags]
```

### Options

```
      --all              Show all statuses (default hides inactive/reference)
      --count            Print only the total number of campaigns
  -f, --format string    Output format (table, simple, json) (default "table")
      --group            Force org grouping
  -h, --help             help for list
      --json             Output as JSON (shorthand for --format json)
      --no-group         Suppress org grouping
      --org string       Only campaigns in this org
  -s, --sort string      Sort by (name, accessed, type) (default "accessed")
      --status string    Only campaigns in this status (active, inactive, reference)
      --tag strings      Only campaigns carrying this tag (repeat for AND)
      --verify-verbose   Show detailed verification output
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
