---
title: "camp triage start"
linkTitle: "camp triage start"
description: "Snapshot the camp and open a triage run"
---

## camp triage start

Snapshot the camp and open a triage run

### Synopsis

Snapshot the camp's workitems and open a triage run.

The snapshot is frozen: the run records what the camp contained when it
started, along with the resolved profile it will be judged under, so a verdict
stays explainable even after the camp and the profile move on.

Scope expressions use the same filters as camp workitem, one per --scope flag:

  --scope type:design            only design workitems
  --scope tag:launch             only items tagged launch
  --scope path:workflow/design   only items under a path (glob)

Available keys: type, category, status, stage, attention-stage, group, tag,
project, query, path.

Refuses (exit 2) when a run is already in progress; close it with
camp triage abandon first.

```
camp triage start [flags]
```

### Options

```
      --full                Re-review every row instead of carrying unchanged verdicts forward
  -h, --help                help for start
      --identity string     Override the profile's identity policy: repair (adopt and report) or strict (refuse and list)
      --json                Output result as a single JSON object
      --no-workflow-doc     Skip the companion WORKFLOW.md scaffold
      --profile string      Use a named built-in profile instead of the camp's: default, sweep, or deep
      --scope stringArray   Limit the run with a key:value filter (repeat for more)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
