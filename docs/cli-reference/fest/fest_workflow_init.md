---
title: "fest workflow init"
linkTitle: "fest workflow init"
description: "Initialize standalone workflow runtime"
---

## fest workflow init

Initialize standalone workflow runtime

### Synopsis

Create .workflow/ next to an existing WORKFLOW.md.

Run from the directory containing WORKFLOW.md. The command refuses to run
inside a festival phase. Use --force to overwrite an existing
.workflow/workflow.yaml.

To scaffold a new WORKFLOW.md and initialize its runtime in one step, use
'fest workflow create <name>' (alias of 'fest create workflow'). init is for a
WORKFLOW.md you have already authored.

This command does not create .workitem; that file is owned by camp
(see 'camp workitem create' and 'camp workitem adopt').

```
fest workflow init [flags]
```

### Options

```
      --force                overwrite existing .workflow/workflow.yaml
  -h, --help                 help for init
      --workflow-id string   workflow_id to write into manifest (defaults to wf-<basename>)
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
