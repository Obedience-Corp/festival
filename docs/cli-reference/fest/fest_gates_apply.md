---
title: "fest gates apply"
linkTitle: "fest gates apply"
description: "Apply quality gates to sequences"
---

## fest gates apply

Apply quality gates to sequences

### Synopsis

Apply quality gate task files to sequences based on phase type.

By default, runs in dry-run mode showing what would change.
Use --approve to actually apply the changes.

Gates are read from the fest.yaml implementation section.
Only implementation phases have quality gates.

Quality gates are only added to sequences not matching excluded_patterns.

```
fest gates apply [flags]
```

### Examples

```
  # Preview changes (dry-run is default)
  fest gates apply

  # Apply to all sequences
  fest gates apply --approve

  # Apply to specific sequence
  fest gates apply --sequence 002_IMPL/01_core --approve

  # Force overwrite modified files
  fest gates apply --approve --force

  # JSON output for automation
  fest gates apply --json
```

### Options

```
      --approve           Apply changes
      --dry-run           Preview changes without applying (default) (default true)
      --force             Overwrite modified files
  -h, --help              help for apply
      --json              Output JSON
      --phase string      Apply to specific phase
      --sequence string   Apply to specific sequence (format: phase/sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest gates](../fest_gates/)	 - Manage quality gates - validation steps at sequence end
