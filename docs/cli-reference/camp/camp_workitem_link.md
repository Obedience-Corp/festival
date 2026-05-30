---
title: "camp workitem link"
linkTitle: "camp workitem link"
description: "Attach a workitem to a project, festival, worktree, or campaign path"
---

## camp workitem link

Attach a workitem to a project, festival, worktree, or campaign path

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
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
