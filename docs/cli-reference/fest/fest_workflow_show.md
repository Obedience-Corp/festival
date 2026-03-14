---
title: "fest workflow show"
linkTitle: "fest workflow show"
description: "Display current step details"
---

## fest workflow show

Display current step details

### Synopsis

Display detailed information about the current workflow step.

If a step number is provided, shows that specific step.
Otherwise, shows the current step.

Shows:
  - Step number and name
  - Goal/objective
  - Actions to complete
  - Expected output
  - Checkpoint type if applicable

```
fest workflow show [step] [flags]
```

### Options

```
  -h, --help   help for show
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest workflow](../fest_workflow/)	 - Manage workflow-based phase execution
