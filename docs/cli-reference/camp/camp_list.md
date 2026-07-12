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

In a terminal, 'camp list' (with no flags) opens an interactive browser where you
can deactivate/reactivate campaigns (cycle lifecycle status), reassign their org,
and copy paths. Piped, with --json/--count, or with any filter/sort flag it
prints the table instead. Home paths display as '~'.

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Campaign names only, one per line
  json    - JSON array for scripting

Sorting options:
  accessed - Most recently accessed first (default)
  name     - Alphabetically by name
  type     - Alphabetically by type
  org      - By org (fallback first, then alphabetical), then by name

Examples:
  camp list                  List all campaigns
  camp list --json           Output as JSON
  camp list --format json    Output as JSON
  camp list --sort name      Sort by name
  camp list --sort org       Sort by org, then name
  camp list --format simple  Names only for scripting
  camp list --count          Print only the total number of campaigns
  camp list --remote         Also list campaigns on machines in ~/.obey/machines.yaml

--remote runs each machine's own 'camp list --json' through a login shell
(sh -lc) so PATH entries a login profile exports (~/.profile, etc.) are
picked up. If camp still can't be found on a machine, set
CAMP_REMOTE_CAMP_PATH to its exact path there.

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
  -i, --interactive      Open the interactive campaign browser (prints the table when stdout is not a terminal)
      --json             Output as JSON (shorthand for --format json)
      --no-group         Suppress org grouping
      --org string       Only campaigns in this org
      --remote           Also list campaigns on machines in ~/.obey/machines.yaml (ssh)
  -s, --sort string      Sort by (name, accessed, type, org) (default "accessed")
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
