## fest wizard

Interactive guidance and assistance for festival creation

### Synopsis

The wizard command provides interactive guidance for festival creation.

SUBCOMMANDS:
  fill <file>    Interactively fill REPLACE markers in a file

EXAMPLES:
  # Fill markers in a specific file
  fest wizard fill PHASE_GOAL.md

  # Fill markers in all files in current directory
  fest wizard fill .

  # Preview changes without writing
  fest wizard fill FESTIVAL_GOAL.md --dry-run

The wizard subcommands help automate tedious tasks and guide users
through the festival creation process step by step.

### Options

```
  -h, --help   help for wizard
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
* [fest wizard fill](fest_wizard_fill.md)	 - Interactively fill REPLACE markers in festival files

