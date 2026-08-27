---
title: "camp workitem list"
linkTitle: "camp workitem list"
description: "List or browse filtered workitems"
---

## camp workitem list

List or browse filtered workitems

### Synopsis

List campaign workitems with the same filters used by the dashboard.

In a terminal, this opens the TUI with visible, editable prefilters. When
stdout is not a terminal, it prints a compact grouped list. Use --json for the
stable machine-readable contract in either environment.

The optional positional filter resolves as a workflow type, displayed status,
or configured category. Ambiguous values must use an explicit flag.

Examples:
  camp workitem list intent
  camp workitem list active
  camp workitem list --category research --query auth
  camp workitem list --tag public-launch --tag schema
  camp workitem list festival --stage ready --json
  camp workitem list --attention-stage active --json

```
camp workitem list [type|status|category] [flags]
```

### Options

```
      --attention-stage stringArray   Filter by attention stage (repeat for OR)
      --category stringArray          Filter by workflow category (repeat for OR)
      --group stringArray             Filter by workitem group (repeat for OR)
      --group-by string               Group output sections by attention_stage, group, type, or category
  -h, --help                          help for list
      --json                          Output as JSON
      --limit int                     Maximum number of items to return (non-interactive / --json only)
      --no-tokens                     Skip token count annotation
      --project stringArray           Filter by related project (repeat for OR)
      --query string                  Search query to filter items
      --show-parked                   Include parked attention-stage workitems
      --stage stringArray             Filter by lifecycle stage (repeat for OR)
      --status stringArray            Deprecated: use --stage and/or --attention-stage
      --tag stringArray               Filter by tag (repeat; item must have ALL given tags)
      --token-model string            Tokenizer model for token counts (default "gpt-4o")
      --type stringArray              Filter by workflow type (repeat for OR)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
