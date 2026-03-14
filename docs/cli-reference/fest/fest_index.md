---
title: "fest index"
linkTitle: "fest index"
description: "Manage festival indices"
---

## fest index

Manage festival indices

### Synopsis

Generate and validate festival indices for Guild integration.

The index file (.festival/index.json) provides a machine-readable representation
of the festival structure, including phases, sequences, and tasks.

For workspace-wide indexing (Guild v3), use the 'tree' subcommand.

### Options

```
  -h, --help   help for index
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest index diff](../fest_index_diff/)	 - Compare tree indexes to detect changes
* [fest index show](../fest_index_show/)	 - Show festival index contents
* [fest index tree](../fest_index_tree/)	 - Generate workspace-wide tree index
* [fest index validate](../fest_index_validate/)	 - Validate festival index against filesystem
* [fest index write](../fest_index_write/)	 - Generate festival index
