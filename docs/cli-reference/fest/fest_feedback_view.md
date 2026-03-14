---
title: "fest feedback view"
linkTitle: "fest feedback view"
description: "View collected feedback"
---

## fest feedback view

View collected feedback

### Synopsis

View collected feedback observations.

Filter by criteria or severity, or view a summary of all feedback.

Examples:
```bash
  fest feedback view
  fest feedback view --criteria "Code quality"
  fest feedback view --severity high
  fest feedback view --summary
  fest feedback view --json
```

```
fest feedback view [flags]
```

### Options

```
      --criteria string   filter by criteria
  -h, --help              help for view
      --json              output in JSON format
      --severity string   filter by severity
      --summary           show summary only
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest feedback](../fest_feedback/)	 - Manage structured feedback collection
