## fest progress

Track and display festival execution progress

### Synopsis

Track and display progress for festival execution.

When run without flags, shows an overview of festival progress.
Use flags to update task progress, report blockers, or mark tasks complete.

PROGRESS OVERVIEW:
  fest progress              Show festival progress summary
  fest progress --json       Output progress in JSON format

TASK UPDATES:
  fest progress --task <id> --update 50%     Update task progress
  fest progress --task <id> --complete       Mark task as complete
  fest progress --task <id> --in-progress    Mark task as in progress
  fest progress --task <id> --blocker "msg"  Report a blocker
  fest progress --task <id> --clear          Clear blocker
  fest progress --path <task_path> --complete
  fest progress --phase <phase> --sequence <seq> --task <id> --complete

Task IDs can be festival-relative paths (e.g. 002_FOUNDATION/01_project_scaffold/01_design.md)
or absolute paths. Use --path or --phase/--sequence to disambiguate duplicates.
Use --festival to run outside a festival directory.

```
fest progress [flags]
```

### Examples

```
  fest progress                          # Show overall progress
  fest progress --task 01_setup.md --update 75%
  fest progress --path 002_FOUNDATION/01_project_scaffold/01_design.md --complete
  fest progress --phase 002_FOUNDATION --sequence 01_project_scaffold --task 01_design.md --complete
  fest progress --festival festivals/active/guild-chat-GC0001 --task 01_setup.md --update 75%
  fest progress --task 02_impl.md --blocker "Waiting on API spec"
  fest progress --task 02_impl.md --clear
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
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

