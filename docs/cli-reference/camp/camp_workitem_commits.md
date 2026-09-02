---
title: "camp workitem commits"
linkTitle: "camp workitem commits"
description: "List commits referencing a workitem"
---

## camp workitem commits

List commits referencing a workitem

### Synopsis

List commits referencing this workitem, newest first.

When the camp event ledger already holds the workitem's commit evidence,
the answer comes from a single merged ledger read (fast path). Otherwise it
falls back to scanning the camp root and every linked
project/repo/worktree/festival repo for commits whose camp tag references
the workitem's ref (pre-ledger history).

Use --json for structured output; the "source" field reports which path
answered ("ledger" or "scan"). Repos that are not git checkouts or that fail
their git log invocation are reported under "errors" in JSON mode; table mode
warns on stderr when repo queries fail.

```
camp workitem commits [selector] [flags]
```

### Options

```
  -h, --help              help for commits
      --json              emit JSON instead of the default table
      --limit int         maximum commits to return (default 100)
      --offset int        number of commits to skip (after sorting)
      --ref string        query by workitem ref directly (e.g. WI-abc123); skips resolver
      --source string     where to read commits from: auto (ledger when present, else scan), ledger, or scan (default "auto")
      --workitem string   alias for the positional <selector>
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active camp work items
