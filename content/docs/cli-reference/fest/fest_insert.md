## fest insert

Insert new festival elements

### Synopsis

Insert a new phase, sequence, or task and renumber subsequent elements.

This command creates a new element and automatically renumbers all
following elements to maintain proper ordering.

### Options

```
      --backup    create backup before changes
      --dry-run   preview changes without applying them (default true)
  -h, --help      help for insert
      --verbose   show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest insert phase](fest_insert_phase.md)	 - Insert a new phase
* [fest insert sequence](fest_insert_sequence.md)	 - Insert a new sequence within a phase
* [fest insert task](fest_insert_task.md)	 - Insert a new task within a sequence

