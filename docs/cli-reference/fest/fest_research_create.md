---
title: "fest research create"
linkTitle: "fest research create"
description: "Create a new research document from template"
---

## fest research create

Create a new research document from template

### Synopsis

Create a new research document using one of the research templates.

Available document types:
  investigation  - Exploring unknowns, gathering information
  comparison     - Evaluating options, making decisions
  analysis       - Deep-dive technical analysis
  specification  - Defining requirements and design

```
fest research create [flags]
```

### Examples

```
  fest research create --type investigation --title "API Authentication Options"
  fest research create --type comparison --title "Database Selection"
  fest research create --type analysis --title "Performance Baseline"
  fest research create --type specification --title "User API Design"
```

### Options

```
  -h, --help           help for create
      --json           Output in JSON format
  -p, --path string    Destination directory (default ".")
      --title string   Document title (required)
  -t, --type string    Document type (investigation|comparison|analysis|specification)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest research](../fest_research/)	 - Manage research phase documents
