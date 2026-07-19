---
title: "camp idea find"
linkTitle: "camp idea find"
description: "Search for ideas by title or content"
---

## camp idea find

Search for ideas by title or content

### Synopsis

Search for ideas across all statuses by title, content, or ID.

The search is case-insensitive and matches partial strings.
Without a query, returns all ideas.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            IDs only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp idea find                   List all ideas
  camp idea find dark              Find ideas containing "dark"
  camp idea find "bug fix"         Find ideas with "bug fix"
  camp idea find -f simple auth    Get IDs of auth-related ideas

```
camp idea find [query] [flags]
```

### Options

```
  -f, --format string   Output format: table, simple, json (default "table")
  -h, --help            help for find
      --json            emit a structured JSON result
  -n, --limit int       Limit results (0 = no limit)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas
