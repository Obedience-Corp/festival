---
title: "camp workitem commit"
linkTitle: "camp workitem commit"
description: "Commit changes scoped to the resolved workitem"
---

## camp workitem commit

Commit changes scoped to the resolved workitem

### Synopsis

Stage and commit changes belonging to a resolved workitem.

The staging plan is computed from the resolver context (cwd-aware, with
explicit positional <selector> or --project overrides) and printed to stderr
before the commit runs. The plan never silently widens to "git add ." at the
campaign root.

See docs/workitem-commit-reference.md for the staging matrix and flag
precedence.

```
camp workitem commit [selector] [flags]
```

### Options

```
      --dry-run                     print the staging plan and exit without committing
      --exclude stringArray         path to remove from the staging plan (repeatable)
      --festival string             festival id for the festival resolver tier
  -h, --help                        help for commit
      --include stringArray         additional path to stage (repeatable; relative to repo root)
      --include-submodule-pointer   include dirty project submodule pointers in the plan
      --json                        emit the staging plan and commit result as JSON on stdout
  -m, --message stringArray         commit message (repeatable; multiple -m are joined git-style into subject + body; required unless --dry-run)
      --project string              force project-repo context by name (skips resolver)
      --staged                      commit whatever is already in the git index
      --workitem string             explicit workitem selector (overrides cwd-based resolution)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
