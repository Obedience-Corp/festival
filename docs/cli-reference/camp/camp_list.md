---
title: "camp list"
linkTitle: "camp list"
description: "List all registered camps"
---

## camp list

List all registered camps

### Synopsis

List all camps registered in the global registry.

Camps are registered when created with 'camp init' or manually
with 'camp register'. The registry lives at ~/.obey/campaign/registry.json.

In a terminal, 'camp list' (with no flags) opens an interactive browser where you
can deactivate/reactivate camps (cycle lifecycle status), reassign their org,
and copy paths. When machines are configured in ~/.obey/machines.yaml, press 'r'
to load remote camps into the browser (not on open). Pass an org as a
positional argument to open the browser filtered to that org. Piped, with
--json/--count, or with any filter/sort flag it prints the table instead. Home
paths display as '~'.

Shell integration (recommended for go/hop from the browser):
  eval "$(camp shell-init zsh)"   # or bash / sh
  camp shell-init fish | source   # fish
  camp list                       # interactive browser; g hops remote rows

Use the shell you actually run. "sh" covers dash, busybox ash, and any other
Bourne shell that is not bash or zsh; the bash script will not parse there.

Output formats:
  table   - Aligned columns with headers (default)
  simple  - camp names only, one per line
  json    - JSON array for scripting

Sorting options:
  accessed - Most recently accessed first (default)
  name     - Alphabetically by name
  type     - Alphabetically by type
  org      - By org (fallback first, then alphabetical), then by name

Examples:
  camp list                  List all camps
  camp list obey             Browse camps in the obey org
  camp list --json           Output as JSON
  camp list --format json    Output as JSON
  camp list --sort name      Sort by name
  camp list --sort org       Sort by org, then name
  camp list --format simple  Names only for scripting
  camp list --count          Print only the total number of camps
  camp list --remote         Also list camps on machines in ~/.obey/machines.yaml

--remote runs each machine's own 'camp list --json' through that account's
configured login shell ($SHELL -lc) so its login-profile PATH is picked up; when
that PATH has no camp, the far side falls back to camp's usual install
locations (~/.local/bin, $GOBIN, $GOPATH/bin, ~/go/bin, Homebrew) before giving
up. If camp lives somewhere else on a machine, set CAMP_REMOTE_CAMP_PATH to its
exact path there. 'camp machine diagnose' shows which binary a hop would run.

For interactive hop to a remote camp from the picker, use csw after
shell-init (see 'camp switch --help').

```
camp list [org] [flags]
```

### Options

```
      --all              Show all statuses (default hides inactive/reference)
      --count            Print only the total number of camps
  -f, --format string    Output format (table, simple, json) (default "table")
      --group            Force org grouping
  -h, --help             help for list
  -i, --interactive      Open the interactive camp browser (prints the table when stdout is not a terminal)
      --json             Output as JSON (shorthand for --format json)
      --no-group         Suppress org grouping
      --org string       Only camps in this org
      --remote           Also list camps on machines in ~/.obey/machines.yaml (ssh)
  -s, --sort string      Sort by (name, accessed, type, org) (default "accessed")
      --status string    Only camps in this status (active, inactive, reference)
      --tag strings      Only camps carrying this tag (repeat for AND)
      --verify-verbose   Show detailed verification output
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
