---
title: "fest chain add"
linkTitle: "fest chain add"
description: "Add a festival to a chain"
---

## fest chain add

Add a festival to a chain

### Synopsis

Add a festival as a node in an existing chain, optionally with prerequisite dependency edges. The mutated chain is validated in memory and written only if valid.
The festival defaults to the current festival context when run inside a festival or linked project.

```
fest chain add [flags]
```

### Options

```
      --after stringArray   prerequisite festival ref/id (repeatable)
      --chain string        target chain id or name
      --festival string     festival to add (id, name, or path)
  -h, --help                help for add
      --json                emit structured JSON result
      --note string         optional edge note
      --type string         edge type: hard | soft (default "hard")
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
