---
title: "fest validate structure"
linkTitle: "fest validate structure"
description: "Validate naming conventions and hierarchy"
---

## fest validate structure

Validate naming conventions and hierarchy

### Synopsis

Validate that festival structure follows naming conventions:

  • Phases: NNN_PHASE_NAME (3-digit prefix, UPPERCASE)
  • Sequences: NN_sequence_name (2-digit prefix, lowercase)
  • Tasks: NN_task_name.md (2-digit prefix, lowercase, .md extension)

```
fest validate structure [festival-path] [flags]
```

### Options

```
  -h, --help   help for structure
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest validate](../fest_validate/)	 - Check festival structure - find missing task files and issues
