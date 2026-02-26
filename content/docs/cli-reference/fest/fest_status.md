## fest status

Manage and query festival entity statuses

### Synopsis

Manage and query status for festivals, phases, sequences, tasks, and gates.

When run without arguments, shows the status of the current entity based on
your working directory location.

EXAMPLES:
  fest status                                  # Status from current directory
  fest status ./festivals/active/my-festival   # Status for specific path
  fest status active/my-festival               # Relative to festivals/ root

SUBCOMMANDS:
  fest status              Show current entity status
  fest status set <status> Change entity status
  fest status list         List entities by status
  fest status history      View status change history

```
fest status [path] [flags]
```

### Options

```
  -h, --help          help for status
      --json          output in JSON format
      --type string   entity type to query (festival, phase, sequence, task, gate)
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
* [fest status history](fest_status_history.md)	 - View status change history
* [fest status list](fest_status_list.md)	 - List entities by status
* [fest status set](fest_status_set.md)	 - Change entity status

