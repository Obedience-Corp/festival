---
title: "fest validate ordering"
linkTitle: "fest validate ordering"
description: "Validate sequential numbering (gap detection)"
---

## fest validate ordering

Validate sequential numbering (gap detection)

### Synopsis

Validate that festival elements are sequentially numbered without gaps.

This checks:
  • Phases are sequential: 001, 002, 003... (no gaps, must start at 001)
  • Sequences within each phase: 01, 02, 03... (no gaps, must start at 01)
  • Tasks within each sequence: 01, 02, 03... (no gaps, must start at 01)

Parallel work (same number) is allowed if items are CONSECUTIVE:
  VALID:   01_task_a.md, 01_task_b.md, 02_task_c.md
  INVALID: 01_task_a.md, 02_task_b.md, 01_task_c.md

Gaps break agent execution order - agents rely on sequential numbering
to determine which phase/sequence/task to work on next.

```
fest validate ordering [festival-path] [flags]
```

### Options

```
  -h, --help   help for ordering
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
