---
title: "fest chain graph"
linkTitle: "fest chain graph"
description: "Visualize chain dependency graph"
---

## fest chain graph

Visualize chain dependency graph

### Synopsis

Render the chain's dependency graph as ASCII waves or Mermaid diagram syntax. The chain id is optional when it can be inferred from the current festival or linked project, or selected interactively in a terminal.

```
fest chain graph [chain-id] [flags]
```

### Options

```
  -h, --help      help for graph
      --live      annotate nodes with live festival statuses
      --mermaid   output Mermaid diagram syntax
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest chain](../fest_chain/)	 - Manage festival chains (inter-festival dependencies)
