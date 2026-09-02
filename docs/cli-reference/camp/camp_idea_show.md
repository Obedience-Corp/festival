---
title: "camp idea show"
linkTitle: "camp idea show"
description: "Show detailed idea information"
---

## camp idea show

Show detailed idea information

### Synopsis

Display detailed information about a specific idea.

Supports partial ID matching - you can use:
  - Full ID: 20260119-153412-add-retry-logic
  - Time suffix: 153412-add-retry
  - Slug portion: add-retry

OUTPUT FORMATS:
  text (default)   Human-readable detailed view
  json             Full metadata in JSON format
  yaml             Full metadata in YAML format

Examples:
  camp idea show 20260119-153412...    Show by full ID
  camp idea show retry-logic           Show by partial match
  camp idea show retry -f json         JSON output
  camp idea show retry -f yaml         YAML output

```
camp idea show <id> [flags]
```

### Options

```
  -f, --format string   Output format: text, json, yaml (default "text")
  -h, --help            help for show
      --json            emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas
