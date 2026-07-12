---
title: "fest workflow runs"
linkTitle: "fest workflow runs"
description: "List runs of a standalone workflow"
---

## fest workflow runs

List runs of a standalone workflow

### Synopsis

List runs recorded in .workflow/workflow.yaml.

Each row shows run id, status, started time, and completed time.

```
fest workflow runs [flags]
```

### Options

```
  -h, --help   help for runs
      --json   emit JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --phase string    specify phase directory (e.g., 001_INGEST)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest workflow](../fest_workflow/)	 - Manage workflow-based phase execution
