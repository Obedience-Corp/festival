---
title: "camp workitem link"
linkTitle: "camp workitem link"
description: "Create a workitem link"
---

## camp workitem link

Create a workitem link

### Synopsis

Attach a workitem to a project, festival, worktree, or campaign path.

Links are stored in .campaign/workitems/links.yaml and connect a .workitem
identity to an explicit scope for planning, execution, and lookup. Pass a
workitem selector plus a path, or use --project, --festival, --worktree, or
--cwd to derive the scope. Use --json for machine-readable link output.

A primary worktree link is how design/explore workitems under workflow/ get
into camp p commit tags: when you commit from that worktree, the resolver
matches the link and stamps WI-<ref> on the subject.

Examples:
  camp workitem link WI-2a7950 --worktree fest/fest-list-watch
  camp workitem link workflow/design/fest-list-watch --worktree projects/worktrees/fest/fest-list-watch
  camp workitem link WI-2a7950 projects/worktrees/fest/fest-list-watch
  # Or at create time:
  camp project worktree add fest-list-watch --project fest --workitem WI-2a7950

```
camp workitem link <selector> [path] [flags]
```

### Options

```
      --allow-missing     allow the workitem and scope target to not exist (migrations)
      --cwd               use current working directory as the scope
      --festival string   festival id or relative path under festivals/
  -h, --help              help for link
      --json              emit a structured JSON result
      --project string    project name (matches projects/<name>)
      --replace           replace an existing primary link on the same scope
      --role string       primary | related | blocked_by | supersedes (default "primary")
      --worktree string   worktree path under projects/worktrees/ (project/name or full projects/worktrees/project/name)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
