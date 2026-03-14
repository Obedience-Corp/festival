---
title: "fest markers next"
linkTitle: "fest markers next"
description: "Show the next file with unfilled markers"
---

## fest markers next

Show the next file with unfilled markers

### Synopsis

Show the next file that needs markers filled, with context hierarchy.

Files are presented in priority order:
1. Festival-level files (FESTIVAL_GOAL.md, FESTIVAL_OVERVIEW.md, TODO.md)
2. Phase-level files (PHASE_GOAL.md for each phase)
3. Sequence-level files (SEQUENCE_GOAL.md for each sequence)
4. Task files (within each sequence)

The context hierarchy is shown to help understand how the file relates to
the overall festival goals.

```
fest markers next [flags]
```

### Options

```
  -h, --help   help for next
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest markers](../fest_markers/)	 - Manage template markers in festival files
