---
title: "fest feedback init"
linkTitle: "fest feedback init"
description: "Initialize feedback collection"
---

## fest feedback init

Initialize feedback collection

### Synopsis

Initialize feedback collection with defined criteria.

Creates a feedback/ directory in the current festival with
configuration for the specified criteria.

Examples:
```bash
  fest feedback init --criteria "Code quality observations"
  fest feedback init --criteria "Performance concerns" --criteria "Methodology suggestions"
  fest feedback init --force --criteria "Usability" --criteria "Release blockers"
```

```
fest feedback init [flags]
```

### Options

```
      --criteria stringArray   feedback criteria (required, repeatable)
      --force                  replace existing criteria while preserving observations
  -h, --help                   help for init
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest feedback](../fest_feedback/)	 - Manage structured feedback collection
