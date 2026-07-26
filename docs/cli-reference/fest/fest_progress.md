---
title: "fest progress"
linkTitle: "fest progress"
description: "Track and display festival execution progress"
---

## fest progress

Track and display festival execution progress

### Synopsis

Track and display progress for festival execution.

When run without flags, shows an overview of festival progress. 'fest progress'
is the display surface; task state mutations live under 'fest task'.

PROGRESS OVERVIEW:
```bash
  fest progress              Show festival progress summary
  fest progress --json       Output progress in JSON format
  fest progress --watch      Continuously refresh the display
```

DEPRECATED TASK MUTATIONS (use 'fest task' instead):
```bash
  fest progress --task <id> --complete   -> fest task completed --yes
  fest progress --task <id> --update 50% -> fest task update 50%
  fest progress --task <id> --blocker "msg" -> fest task blocked --reason "msg" --yes
  fest progress --task <id> --clear      -> fest task unblock
```

These flags still work for one release and print a deprecation notice.

Task IDs can be festival-relative paths (e.g. 002_FOUNDATION/01_project_scaffold/01_design.md)
or absolute paths. Use --path or --phase/--sequence to disambiguate duplicates.
Use --festival to run outside a festival directory.

```
fest progress [flags]
```

### Examples

```
  fest progress                          # Show overall progress
  fest progress --json                   # Overall progress as JSON
  fest progress --watch                  # Live-refreshing progress display
  fest progress --task 01_setup.md       # Show a single task's progress
```

### Options

```
      --blocker string      report a blocker with message
      --clear               clear blocker for task
      --complete            mark task as complete
      --festival string     festival root path (directory containing fest.yaml)
  -h, --help                help for progress
      --in-progress         mark task as in progress
      --interval duration   refresh interval for watch mode (default 2s)
      --json                output in JSON format
      --path string         task path (festival-relative or absolute)
      --phase string        phase directory name for task path
      --sequence string     sequence directory name for task path
      --task string         task ID to update
      --update string       update progress percentage (e.g., 50%)
      --watch               continuously refresh progress display
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
