---
title: "fest types festival show"
linkTitle: "fest types festival show"
description: "Show details for a festival type"
---

## fest types festival show

Show details for a festival type

### Synopsis

Display detailed information about a specific festival type.

Shows the type's description, phase structure, auto-scaffolded phases,
and manually-created phases.

Examples:
```bash
  fest types festival show standard           # Show standard type details
  fest types festival show implementation     # Show implementation type
  fest types festival show standard --phases  # Show only phases
  fest types festival show quick --json       # JSON output
```

```
fest types festival show <type-name> [flags]
```

### Options

```
  -h, --help     help for show
      --json     Output as JSON
      --phases   Show only phases
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest types festival](../fest_types_festival/)	 - Discover festival types
