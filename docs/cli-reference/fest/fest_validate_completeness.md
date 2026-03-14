---
title: "fest validate completeness"
linkTitle: "fest validate completeness"
description: "Validate required files exist"
---

## fest validate completeness

Validate required files exist

### Synopsis

Validate that all required files exist:

  • FESTIVAL_OVERVIEW.md (required)
  • PHASE_GOAL.md in each phase (required)
  • SEQUENCE_GOAL.md in each sequence (required)
  • FESTIVAL_RULES.md (recommended)

```
fest validate completeness [festival-path] [flags]
```

### Options

```
  -h, --help   help for completeness
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest validate](../fest_validate/)	 - Check festival structure - find missing task files and issues
