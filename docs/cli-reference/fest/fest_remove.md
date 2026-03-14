---
title: "fest remove"
linkTitle: "fest remove"
description: "Remove festival elements and renumber"
---

## fest remove

Remove festival elements and renumber

### Synopsis

Remove a phase, sequence, or task and automatically renumber subsequent elements.

This command safely removes elements and maintains proper numbering
for all following elements in the hierarchy.

### Options

```
      --backup    create backup before removal
      --dry-run   preview changes without applying them (default true)
      --force     skip confirmation prompts
  -h, --help      help for remove
      --verbose   show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest remove phase](../fest_remove_phase/)	 - Remove a phase and renumber subsequent phases
* [fest remove sequence](../fest_remove_sequence/)	 - Remove a sequence and renumber subsequent sequences
* [fest remove task](../fest_remove_task/)	 - Remove a task and renumber subsequent tasks
