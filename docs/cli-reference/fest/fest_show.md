---
title: "fest show"
linkTitle: "fest show"
description: "Display festival information"
---

## fest show

Display festival information

### Synopsis

Display festival information for a single festival.

When run inside a festival directory, shows the current festival's details.
When run outside a festival in an interactive campaign workspace, opens a
cyclable view; use ←/→ to move between festivals and q/Ctrl+C to exit.

```bash
  fest show                        Show current festival, or cycle festivals in a workspace
  fest show <name>                 Show details of a specific festival by name
  fest show --festival <selector>  Show a festival by explicit selector (campaign workspace)
```

To list festivals by status, use 'fest list' (e.g. 'fest list active',
'fest list all', 'fest list dungeon/completed').

```
fest show [festival-name] [flags]
```

### Examples

```
  fest show
  fest show launch-readiness
  fest show --festival LR0001
```

### Options

```
      --collapsed         show collapsed tree with counters only
      --festival string   festival selector (name or ID) from within a campaign workspace
      --goals             show goals for phases and sequences
  -h, --help              help for show
      --inprogress        expand only in-progress phases and sequences
      --json              output in JSON format
      --roadmap           show full execution roadmap with task statuses
      --summary           show aggregate summary instead of tree view
      --watch             continuously refresh display
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
