---
title: "camp workitem validate"
linkTitle: "camp workitem validate"
description: "Validate workitem directories"
---

## camp workitem validate

Validate workitem directories

### Synopsis

Validate that workflow work item directories carry a correct .workitem marker.

Without an argument, every work item directory under workflow/ is scanned:
builtin doc directories (workflow/design, workflow/explore) are always work
items, custom type directories surface only when they carry a marker, and
dungeon/hidden control areas are ignored. With a path argument, only that
directory is validated.

Each problem prints the exact repair command, for example
"camp workitem repair workflow/design/foo". Use --json for stable finding
codes. The command exits non-zero when any error-severity finding is present.

```
camp workitem validate [path] [flags]
```

### Options

```
  -h, --help   help for validate
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active camp work items
