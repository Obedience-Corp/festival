---
title: "camp registry check"
linkTitle: "camp registry check"
description: "Check registry integrity"
---

## camp registry check

Check registry integrity

### Synopsis

Validate the registry and report any issues found.

Checks for:
- Stale entries (paths that don't exist)
- Missing .campaign/ directories
- Campaigns in /tmp/ directories
- Duplicate entries (multiple IDs pointing to the same path)

Examples:
  camp registry check   Show any registry issues

```
camp registry check [flags]
```

### Options

```
  -h, --help   help for check
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp registry](../camp_registry/)	 - Manage the campaign registry
