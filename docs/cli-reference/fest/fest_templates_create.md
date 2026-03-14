---
title: "fest templates create"
linkTitle: "fest templates create"
description: "Create a new template"
---

## fest templates create

Create a new template

### Synopsis

Create a new agent template in the current festival.

The template will be stored in .templates/<name>.md

Example template content:
```bash
  # {{component_name}} Test

  ## Setup
  {{setup_steps}}

  ## Test Cases
  - {{test_case_1}}
  - {{test_case_2}}
```

```
fest templates create <name> [flags]
```

### Options

```
      --from-file string   create from existing file
  -h, --help               help for create
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest templates](../fest_templates/)	 - Manage agent-created templates within a festival
