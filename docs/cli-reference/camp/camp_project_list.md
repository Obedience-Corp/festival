---
title: "camp project list"
linkTitle: "camp project list"
description: "List projects in camp"
---

## camp project list

List projects in camp

### Synopsis

List all projects in the current camp.

Projects are discovered from the projects/ directory. They may be regular
git-backed entries or linked external directories.

In a terminal, 'camp project list' (with no flags) opens an interactive
browser. Press / to filter (letters including g type into the query; j/k
move among matches; enter jumps), and from the browse list g or enter jumps
to the selected project when shell integration is loaded:

  eval "$(camp shell-init zsh)"   # or bash / sh
  camp shell-init fish | source   # fish
  camp project list               # interactive browser; g cds into the project

Piped, with --json/--count, or with a non-table --format it prints that
format instead. -i forces the browser (and still prints the table when stdout
is not a terminal).

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Project names only, one per line
  json    - JSON array for scripting

Examples:
  camp project list               Browse projects (TTY) or print the table
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
  -i, --interactive     Open the interactive project browser (prints the table when stdout is not a terminal)
      --json            Output as JSON (shorthand for --format json)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
