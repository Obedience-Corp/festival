---
title: "fest types festival"
linkTitle: "fest types festival"
description: "Discover festival types"
---

## fest types festival

Discover festival types

### Synopsis

Discover available festival types and their phase structures.

Festival types define the workflow structure for different kinds of projects:
  - standard: Full planning and implementation phases
  - implementation: Direct implementation without planning
  - research: Research-focused workflow
  - quick: Fast, minimal overhead workflow
  - ritual: Simple repeating patterns

Examples:
```bash
  fest types festival                    # List all festival types
  fest types festival list               # Same as above
  fest types festival standard           # Show details for standard type
  fest types festival show implementation # Show details for implementation type
  fest types festival --phases standard  # Show only phases for standard type
  fest types festival --json             # Machine-readable JSON output
```

```
fest types festival [type-name] [flags]
```

### Options

```
  -h, --help     help for festival
      --json     Output as JSON
      --phases   Show only phases for the specified type
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest types](../fest_types/)	 - Discover and explore template types
* [fest types festival list](../fest_types_festival_list/)	 - List all festival types
* [fest types festival show](../fest_types_festival_show/)	 - Show details for a festival type
