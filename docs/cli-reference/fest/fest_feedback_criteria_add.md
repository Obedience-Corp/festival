---
title: "fest feedback criteria add"
linkTitle: "fest feedback criteria add"
description: "Add feedback criteria"
---

## fest feedback criteria add

Add feedback criteria

### Synopsis

Add criteria to existing feedback collection.

Each --criteria value is treated literally, so commas are preserved.

Examples:
```bash
  fest feedback criteria add --criteria "Onboarding friction, especially copied commands"
  fest feedback criteria add --criteria "Performance" --criteria "Documentation gaps"
```

```
fest feedback criteria add [flags]
```

### Options

```
      --criteria stringArray   feedback criteria to add (required, repeatable)
  -h, --help                   help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest feedback criteria](../fest_feedback_criteria/)	 - Manage feedback criteria
