---
title: "camp workitem worktree"
linkTitle: "camp workitem worktree"
description: "Create a project worktree from a workitem"
---

## camp workitem worktree

Create a project worktree from a workitem

### Synopsis

Create a git worktree for a workitem and primary-link it, so commits in
that worktree carry the workitem's WI-* tag.

This is the workitem-first counterpart to 'camp project worktree add': instead
of naming a worktree and optionally tagging a workitem, you name a workitem and
the worktree name, branch, and link are derived from it.

Project resolution:
  The target project is taken from the workitem's linked project (see
  'camp workitem link --project'). When the workitem has no project link, or
  is linked to more than one, pass --project explicitly.

Re-entry:
  If the workitem already has a primary worktree link, the existing path is
  printed and no new worktree is created.

Examples:
  # Festival workitem already linked to a project
  camp workitem worktree WI-2a7950

  # Design/explore/intent workitem: name the project
  camp workitem worktree workflow/design/camp-settings-tui --project camp

  # Override the derived worktree name
  camp workitem worktree WI-2a7950 --name grok-list-fix

  # Print only the path (for shell integration)
  cd "$(camp workitem worktree WI-2a7950 --print)"

```
camp workitem worktree <selector> [flags]
```

### Options

```
  -h, --help                 help for worktree
      --name string          Worktree/branch name (derived from the workitem if omitted)
      --print                Print only the worktree path
  -p, --project string       Project name (inferred from the workitem's project link if omitted)
  -s, --start-point string   Base branch/commit for the new branch (default: current branch)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
