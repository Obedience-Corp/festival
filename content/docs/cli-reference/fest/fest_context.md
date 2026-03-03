## fest context

Get context for the current location or task

### Synopsis

Provides AI agents with context for the current location in a festival.

Context includes:
  - Festival, phase, and sequence goals
  - Relevant rules from FESTIVAL_RULES.md
  - Recent decisions from CONTEXT.md
  - Dependency outputs (what prior tasks produced)

Depth levels:
  minimal   - Immediate goals, dependencies, autonomy level
  standard  - + Rules, recent decisions (5)
  full      - + All decisions, dependency outputs

Examples:
```
  fest context                    # Context for current location
  fest context --depth full       # Full context with all details
  fest context --task my_task     # Context for a specific task
  fest context --json             # Output as JSON
  fest context --verbose          # Explanatory output for agents
```

```
fest context [flags]
```

### Options

```
      --depth string   context depth (minimal, standard, full) (default "standard")
  -h, --help           help for context
      --json           output as JSON
      --task string    get context for a specific task
      --verbose        output with explanatory text for agents
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

