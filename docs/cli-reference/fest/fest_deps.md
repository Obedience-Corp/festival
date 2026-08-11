---
title: "fest deps"
linkTitle: "fest deps"
description: "Show task dependencies"
---

## fest deps

Show task dependencies

### Synopsis

Display dependency information for tasks in the festival.

Without arguments, shows the dependency graph for the current sequence.
With a task name, shows dependencies for that specific task.

Examples:
```bash
  fest deps                    # Show all deps in current sequence
  fest deps 02_implement       # Show deps for specific task
  fest deps --all              # Show all deps in festival
  fest deps --json             # Output as JSON
  fest deps --critical-path    # Show critical path through the DAG
  fest deps --ready            # Show every task that is unblocked right now
  fest deps --ready --all --json   # The whole festival's ready set, for orchestrators
```

The --ready set is the execution front: tasks whose hard dependencies are all
complete and which are not themselves complete or blocked. Unlike 'fest next',
which returns a single step, --ready returns every task that could be started
now, so an orchestrator can fan them out concurrently.

```
fest deps [task] [flags]
```

### Options

```
      --all             show all dependencies in festival
      --critical-path   show the critical path
  -h, --help            help for deps
      --json            output as JSON
      --ready           show only tasks that are unblocked right now
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
