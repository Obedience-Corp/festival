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
* [camp workitem create](../camp_workitem_create/)	 - Create a new workitem with v1 minimum metadata
