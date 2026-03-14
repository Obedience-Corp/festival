---
title: "fest types"
linkTitle: "fest types"
description: "Discover and explore template types"
---

## fest types

Discover and explore template types

### Synopsis

Explore available template types at each festival level.

Template types define the structure and purpose of festivals, phases,
sequences, and tasks. Custom types can be added in .festival/templates/.

Examples:
```bash
  fest types list                        # List all available types
  fest types list --level task           # List task-level types only
  fest types show feature                # Show details about a type
  fest types show implementation --level phase
```

### Options

```
  -h, --help   help for types
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
* [fest types festival](../fest_types_festival/)	 - Discover festival types
* [fest types list](../fest_types_list/)	 - List available template types
* [fest types show](../fest_types_show/)	 - Show details about a template type
