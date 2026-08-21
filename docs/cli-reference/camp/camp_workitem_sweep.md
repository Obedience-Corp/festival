---
title: "camp workitem sweep"
linkTitle: "camp workitem sweep"
description: "Act on workitems with completed runs"
---

## camp workitem sweep

Act on workitems with completed runs

### Synopsis

Act on every workitem whose workflow run has completed (tier-1
evidence-driven completion).

What a completed run entitles a workitem to depends on its type:

  bug, chore, feature, custom   The loop was the work, so the item is promoted
                                to its local dungeon/completed.
  explore, research             The loop produced findings that need a home.
  design                        Never promoted here: a design is done when it is
                                implemented, so it waits for a merged branch or a
                                completed festival instead.

Without --prompt the command promotes what it can and reports the rest, which is
what an agent or a script wants. With --prompt it asks per item on a terminal and
can also route findings into docs/, shelve, or leave the item alone; on a non-TTY
or with --json it reports instead, because nothing can answer.

Two guards apply in every mode. A directory written within the last ten minutes
is left alone (a session is probably still working in it), and without --prompt a
directory holding a link is left alone too rather than moved out from under
whoever holds it. Both are reported with their reason.

Only loop-completion evidence (workflow_run_completed) drives this sweep;
merged-branch evidence is handled separately by camp fresh. Festivals and intents
are excluded.

Each item moves independently: a failure on one (dirty git state, a path
collision at its destination) is reported and the sweep continues to the next.
Use --dry-run to see the plan without moving anything, and --json for a
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
      --prompt    Ask per workitem on a terminal instead of promoting automatically
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
