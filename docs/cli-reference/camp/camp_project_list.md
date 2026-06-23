---
title: "camp project list"
linkTitle: "camp project list"
description: "List projects in campaign"
---

## camp project list

List projects in campaign

### Synopsis

List all projects in the current campaign.

Projects are discovered from the projects/ directory. They may be regular
git-backed entries or linked external directories.

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Project names only, one per line
  json    - JSON array for scripting

Examples:
  camp project list               List projects in table format
  camp project list --json        Output as JSON
  camp project list --format json Output as JSON
  camp project list --format simple  Names only for scripting
  camp project list --count       Print only the total number of projects

```
camp project list [flags]
```

### Options

```
      --count           Print only the total number of projects
  -f, --format string   Output format (table, simple, json) (default "table")
  -h, --help            help for list
      --json            Output as JSON (shorthand for --format json)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage campaign projects
