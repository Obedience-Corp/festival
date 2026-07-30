---
title: "fest types list"
linkTitle: "fest types list"
description: "List available template types"
---

## fest types list

List available template types

### Synopsis

List types you can pass to fest create, grouped by level.

Sources:
  - Festival workflow types from festival_types.yaml (create festival --type)
  - Phase/sequence/task scaffold packages under the methodology templates tree
    (~/.obey/fest/festivals/.festival/templates or campaign festivals/.festival/templates)
  - Custom overrides in a festival's .festival/templates/

Examples:
```bash
  fest types list                      # All levels
  fest types list --level festival     # create festival --type values
  fest types list --level phase        # create phase --type values
  fest types list --json               # Machine-readable output
```

```
fest types list [flags]
```

### Options

```
  -a, --all            Show additional details including marker counts
  -c, --custom         Show only custom (user-defined) types
  -h, --help           help for list
      --json           Output as JSON
  -l, --level string   Filter by level (festival, phase, sequence, task)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest types](../fest_types/)	 - Discover types for fest create
