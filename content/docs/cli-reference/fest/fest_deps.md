## fest deps

Show task dependencies

### Synopsis

Display dependency information for tasks in the festival.

Without arguments, shows the dependency graph for the current sequence.
With a task name, shows dependencies for that specific task.

Examples:
  fest deps                    # Show all deps in current sequence
  fest deps 02_implement       # Show deps for specific task
  fest deps --all              # Show all deps in festival
  fest deps --json             # Output as JSON
  fest deps --critical-path    # Show critical path through the DAG

```
fest deps [task] [flags]
```

### Options

```
      --all             show all dependencies in festival
      --critical-path   show the critical path
  -h, --help            help for deps
      --json            output as JSON
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

