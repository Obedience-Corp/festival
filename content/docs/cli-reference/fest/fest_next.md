## fest next

Find the next task to work on

### Synopsis

Determine the next task to work on based on dependencies and progress.

The command analyzes the festival structure, checks task completion status,
and recommends the next task following the priority order:

1. Tasks in current sequence with satisfied dependencies
2. Next incomplete task in current phase
3. First incomplete task in earliest phase
4. Quality gates before phase transitions

By default, shows layered goals and full task content inline to provide
complete context for execution.

Output Modes:
  (default)      Layered goals + full task content inline
  --no-context   Hide inline content, show minimal output
  --path         Just the task file path (relative, for piping)
  --short        Task path with status message
  --cd           Directory path for shell cd
  --json         Full result as JSON
  --verbose      Detailed human-readable output

Examples:
  fest next                    # Find next task with full context
  fest next --no-context       # Minimal output without task content
  fest next --sequence         # Only consider current sequence
  fest next --json             # Output as JSON
  fest next --verbose          # Detailed output
  fest next --short            # Just the task path
  fest next --cd               # Output directory for shell cd
  fest next --path             # Just the relative file path

```
fest next [flags]
```

### Options

```
      --cd            output directory path for cd command
  -h, --help          help for next
      --json          output as JSON
  -m, --mode string   override phase type detection (implementation|plan|research|review|action|ingest)
      --navigator     use guidance navigator for output formatting
      --no-context    hide inline content (show minimal output)
      --path          output only the relative task file path
      --sequence      only consider current sequence
      --short         output only the task path
      --verbose       show detailed information
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

