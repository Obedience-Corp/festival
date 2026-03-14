---
title: "fest reorder"
linkTitle: "fest reorder"
description: "Reorder festival elements"
---

## fest reorder

Reorder festival elements

### Synopsis

Reorder phases, sequences, or tasks by moving an element from one position to another.

This command moves an element to a new position and shifts other elements
accordingly to maintain proper ordering.

### Options

```
      --backup         create backup before reordering
      --dry-run        preview changes without applying them (default true)
      --force          skip confirmation prompts
  -h, --help           help for reorder
      --skip-dry-run   skip preview and apply changes immediately
      --verbose        show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest reorder phase](../fest_reorder_phase/)	 - Reorder phases in a festival
* [fest reorder sequence](../fest_reorder_sequence/)	 - Reorder sequences within a phase
* [fest reorder task](../fest_reorder_task/)	 - Reorder tasks within a sequence
