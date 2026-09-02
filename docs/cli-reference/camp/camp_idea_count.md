---
title: "camp idea count"
linkTitle: "camp idea count"
description: "Count ideas by status directory"
---

## camp idea count

Count ideas by status directory

### Synopsis

Display a count of ideas grouped by status directory.

OUTPUT FORMATS:
  table (default)   Styled summary with counts per status
  json              Machine-readable JSON output

Examples:
  camp idea count              Show counts per status
  camp idea count -f json      JSON output for scripting

```
camp idea count [flags]
```

### Options

```
  -f, --format string   Output format: table, json (default "table")
  -h, --help            help for count
      --json            emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas
