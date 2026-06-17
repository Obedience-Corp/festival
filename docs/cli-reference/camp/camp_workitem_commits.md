---
title: "camp workitem commits"
linkTitle: "camp workitem commits"
description: "List commits referencing a workitem across linked repos"
---

## camp workitem commits

List commits referencing a workitem across linked repos

### Synopsis

Search the campaign root and every linked project/repo/worktree/festival
repo for commits whose campaign tag references this workitem's ref.

Default sort: most recent first across all repos. Use --json for structured
output. Repos that are not git checkouts or that fail their git log invocation
are reported under "errors" in JSON mode; table mode warns on stderr when
repo queries fail.

```
camp workitem commits [selector] [flags]
```

### Options

```
  -h, --help              help for commits
      --json              emit JSON instead of the default table
      --limit int         maximum commits to return (default 100)
      --offset int        number of commits to skip (after sorting)
      --ref string        query by workitem ref directly (e.g. WI-abc123) — skips resolver
      --workitem string   alias for the positional <selector>
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
