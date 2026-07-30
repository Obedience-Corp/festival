---
title: "fest types show"
linkTitle: "fest types show"
description: "Show details about a template type"
---

## fest types show

Show details about a template type

### Synopsis

Display detailed information about a specific type.

Shows the type's level, description, markers, template files, and example usage.

Examples:
```bash
  fest types show standard                      # Festival workflow type
  fest types show implementation --level phase  # Phase scaffold type
  fest types show default --level task --json   # Task package
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
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest types](../fest_types/)	 - Discover types for fest create
