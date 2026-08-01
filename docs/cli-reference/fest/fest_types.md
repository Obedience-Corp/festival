---
title: "fest types"
linkTitle: "fest types"
description: "Discover types for fest create"
---

## fest types

Discover types for fest create

### Synopsis

List festival, phase, sequence, and task types available for create.

Festival workflow types (standard, implementation, research, ritual) come from
festival_types.yaml. Phase scaffold types come from the methodology templates
tree under festivals/.festival/templates/phases/.

Examples:
```bash
  fest types                             # Same as fest types list
  fest types list --level festival       # Values for create festival --type
  fest types list --level phase          # Values for create phase --type
  fest types show standard               # Festival workflow type details
  fest types show implementation --level phase
  fest types festival                    # Festival workflow types (alias)
```

```
fest types [flags]
```

### Options

```
  -h, --help   help for types
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
* [fest types festival](../fest_types_festival/)	 - Discover festival types
* [fest types list](../fest_types_list/)	 - List available template types
* [fest types show](../fest_types_show/)	 - Show details about a template type
