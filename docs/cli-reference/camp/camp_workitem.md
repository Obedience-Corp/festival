---
title: "camp workitem"
linkTitle: "camp workitem"
description: "View active campaign work items"
---

## camp workitem

View active campaign work items

### Synopsis

View active campaign work items across intents, designs, explore, and festivals.

Default mode launches an interactive TUI dashboard. Use --json for machine-readable
output or --print to select and print a path for shell integration.

Examples:
  camp workitem                              # interactive dashboard
  camp workitem --json                       # JSON output for agents/scripts
  camp workitem --json --type design         # filter by type
  camp workitem --json --type intent --limit 5
  camp workitem --print                      # select and print path

```
camp workitem [flags]
```

### Options

```
  -h, --help                help for workitem
      --json                Output as JSON
      --limit int           Maximum number of items to return
      --print               Print path only (for shell integration)
      --query string        Search query to filter items
      --stage stringArray   Filter by lifecycle stage (inbox, active, ready, planning)
      --type stringArray    Filter by workflow type (builtin: intent, design, explore, festival; or any slug-safe custom type produced by 'camp workitem create --type <name>')
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp workitem adopt](../camp_workitem_adopt/)	 - Attach .workitem metadata to an existing directory
* [camp workitem commit](../camp_workitem_commit/)	 - Commit changes scoped to the resolved workitem
* [camp workitem commits](../camp_workitem_commits/)	 - List commits referencing a workitem across linked repos
* [camp workitem create](../camp_workitem_create/)	 - Create a new workitem with v1 minimum metadata
* [camp workitem current](../camp_workitem_current/)	 - Get, set, or clear the local current workitem
* [camp workitem doctor](../camp_workitem_doctor/)	 - Report workitem link-registry health issues
* [camp workitem link](../camp_workitem_link/)	 - Attach a workitem to a project, festival, worktree, or campaign path
* [camp workitem links](../camp_workitem_links/)	 - List workitem links
* [camp workitem priority](../camp_workitem_priority/)	 - Set or clear the manual priority of a workitem
* [camp workitem resolve](../camp_workitem_resolve/)	 - Print the workitem the current context resolves to (read-only)
* [camp workitem unlink](../camp_workitem_unlink/)	 - Remove one or more workitem links
