---
title: "fest workflow judge"
linkTitle: "fest workflow judge"
description: "Run the approval judge for the current checkpoint"
---

## fest workflow judge

Run the approval judge for the current checkpoint

### Synopsis

Run the configured approval judge for the current blocking checkpoint.

Use this after revising evidence following a judge rejection. A judge-owned
rejection is reopened automatically; ordinary operator rejections still
require 'fest workflow approve'. By default the judge runs in the background;
use --wait when this command should wait for the verdict.

The judge command is resolved from --judge-command or the
hooks.definitions.approval_judge workspace configuration hook.

```
fest workflow judge [flags]
```

### Options

```
  -h, --help                     help for judge
      --judge-command string     approval judge command (overrides hooks.definitions.approval_judge; requires an interactive TTY)
      --judge-timeout duration   maximum time to wait for the approval judge (0 waits until it returns)
      --wait                     block until the judge returns instead of launching it in the background
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
