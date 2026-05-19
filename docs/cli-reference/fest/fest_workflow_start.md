---
title: "fest workflow start"
linkTitle: "fest workflow start"
description: "Start a new run for a standalone workflow"
---

## fest workflow start

Start a new run for a standalone workflow

### Synopsis

Create a new .workflow/runs/<run-id>/ directory and mark it active.

Requires .workflow/workflow.yaml to exist (run fest workflow init first).

```
fest workflow start [flags]
```

### Options

```
  -h, --help   help for start
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
