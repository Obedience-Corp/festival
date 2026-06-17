---
title: "camp workitem link"
linkTitle: "camp workitem link"
description: "Attach a workitem to a project, festival, worktree, or campaign path"
---

## camp workitem link

Attach a workitem to a project, festival, worktree, or campaign path

### Synopsis

Attach a workitem to a project, festival, worktree, or campaign path.

Links are stored in .campaign/workitems/links.yaml and connect a .workitem
identity to an explicit scope for planning, execution, and lookup. Pass a
workitem selector plus a path, or use --project, --festival, --worktree, or
--cwd to derive the scope. Use --json for machine-readable link output.

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
      --worktree string   worktree relative path under projects/worktrees/
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
