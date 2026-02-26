## fest renumber

Renumber festival elements

### Synopsis

Renumber phases, sequences, or tasks in a festival structure.

This command helps maintain proper numbering when elements are added,
removed, or reordered in the festival hierarchy.

### Options

```
      --backup         create backup before renumbering
      --dry-run        preview changes without applying them (default true)
  -h, --help           help for renumber
      --skip-dry-run   skip preview and apply changes immediately
      --start int      starting number for renumbering (default 1)
      --verbose        show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest renumber phase](fest_renumber_phase.md)	 - Renumber phases in a festival
* [fest renumber sequence](fest_renumber_sequence.md)	 - Renumber sequences within a phase
* [fest renumber task](fest_renumber_task.md)	 - Renumber tasks within a sequence

