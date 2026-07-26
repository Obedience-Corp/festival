---
title: "camp workitem sweep"
linkTitle: "camp workitem sweep"
description: "Promote workitems with completed runs"
---

## camp workitem sweep

Promote workitems with completed runs

### Synopsis

Promote every workitem whose active workflow run has completed to its
local dungeon (tier-1 evidence-driven completion).

Only loop-completion evidence (workflow_run_completed) drives this sweep, and it
only ever auto-promotes; merged-branch evidence is handled separately by camp
fresh, which prompts. Festivals and intents are excluded.

Each eligible item moves independently: a failure on one (dirty git state, a
path collision at its destination) is reported and the sweep continues to the
next. Use --dry-run to see the plan without moving anything, and --json for a
structured result. In table mode any per-item failure yields a non-zero exit,
matching camp fresh; --json reports failures in the payload (failed count and
per-item error) and stays exit 0 so the structured result is the contract.

```
camp workitem sweep [flags]
```

### Options

```
      --dry-run   Print the sweep plan, change nothing
  -h, --help      help for sweep
      --json      Output result as a single JSON object
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
