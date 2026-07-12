---
title: "fest chain validate"
linkTitle: "fest chain validate"
description: "Validate a festival chain"
---

## fest chain validate

Validate a festival chain

### Synopsis

Run all structural validation checks (S1-S10) against a chain definition.
The chain id is optional when it can be inferred from the current festival or linked project, or selected interactively in a terminal.
Use --cross to validate across all chains.

```
fest chain validate [chain-id] [flags]
```

### Options

```
      --cross   validate across all chains (duplicate IDs, conflicts)
  -h, --help    help for validate
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest chain](../fest_chain/)	 - Manage festival chains (inter-festival dependencies)
