---
title: "fest types show"
linkTitle: "fest types show"
description: "Show details about a template type"
---

## fest types show

Show details about a template type

### Synopsis

Display detailed information about a specific template type.

Shows the type's level, description, number of markers, template files,
and example usage.

Examples:
```bash
  fest types show feature                   # Show feature type details
  fest types show implementation --level phase  # Show phase-level implementation
  fest types show simple --level task --json    # JSON output
```

```
fest types show <type-name> [flags]
```

### Options

```
  -h, --help           help for show
      --json           Output as JSON
  -l, --level string   Filter by level (disambiguate if same name at multiple levels)
  -t, --template       Show raw template content
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
