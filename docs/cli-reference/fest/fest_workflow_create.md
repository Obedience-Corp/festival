---
title: "fest workflow create"
linkTitle: "fest workflow create"
description: "Scaffold a new standalone WORKFLOW.md (alias of 'fest create workflow')"
---

## fest workflow create

Scaffold a new standalone WORKFLOW.md (alias of 'fest create workflow')

### Synopsis

Alias of 'fest create workflow'.

Outside a festival phase, this creates WORKFLOW.md in the current directory,
initializes .workflow/ runtime state, and starts a tracked run so 'fest next'
works immediately.

Unlike the other 'fest workflow' subcommands (init, start, show, advance), which
operate on an existing WORKFLOW.md, this one scaffolds a brand-new document.

Examples:
```bash
  fest workflow create demo
  fest workflow create demo --steps '{"title":"Review","steps":[...]}'
  fest workflow create demo --steps-file steps.json
```

```
fest workflow create [name] [flags]
```

### Options

```
      --agent               Strict agent mode (implies --json)
      --festival string     Festival root override
  -h, --help                help for create
      --json                Emit JSON output
      --no-init             skip .workflow/ runtime init (advanced standalone mode)
      --path string         Phase directory path (festival mode) (default ".")
      --position string     Workflow position relative to sequences (before|after) (default "after")
      --steps string        Inline JSON with workflow definition
      --steps-file string   Path to JSON file with workflow definition
      --type string         workflow type (standalone mode only) (default "task")
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
