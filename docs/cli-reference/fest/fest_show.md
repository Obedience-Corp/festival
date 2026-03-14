---
title: "fest show"
linkTitle: "fest show"
description: "Display festival information"
---

## fest show

Display festival information

### Synopsis

Display festival information by status or show details of a specific festival.

When run inside a festival directory, shows the current festival's details.
When run with a status argument, lists all festivals with that status.

SUBCOMMANDS:
```bash
  fest show              Show current festival (detect from cwd)
  fest show active       List festivals in active/ directory
  fest show planning     List festivals in planning/ directory
  fest show completed    List festivals in completed/ directory
  fest show dungeon      List festivals in dungeon/ directory
  fest show all          List all festivals grouped by status
  fest show <name>       Show details of a specific festival by name
  fest show --festival <selector>  Show a festival by explicit selector (campaign workspace)
```

```
fest show [status|festival-name] [flags]
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
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest show active](../fest_show_active/)	 - List festivals in active/ directory
* [fest show all](../fest_show_all/)	 - List all festivals grouped by status
* [fest show completed](../fest_show_completed/)	 - List completed festivals
* [fest show dungeon](../fest_show_dungeon/)	 - List festivals in dungeon/ directory
* [fest show planning](../fest_show_planning/)	 - List festivals in planning/ directory
