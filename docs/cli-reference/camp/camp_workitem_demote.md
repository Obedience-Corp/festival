---
title: "camp workitem demote"
linkTitle: "camp workitem demote"
description: "Move a rail resident back to its type root"
---

## camp workitem demote

Move a rail resident back to its type root

### Synopsis

Take the workitem identified by [id], by cwd, or by the current pointer off the
festival rail and back to its original workflow type root.

A resident in festivals/ready or festivals/active returns to
workflow/<type>/<slug>, where the type comes from its own .workitem marker. Every
reference is repaired in the same commit, exactly as the rail move does.

This is the escape hatch from the rail, not backward motion along it. It is
rejected from a dungeon, because restoring a shelved workitem is not a demote,
and from a workitem already at its type root.

```
camp workitem demote [id] [flags]
```

### Options

```
      --dry-run     Print the planned move, change nothing
  -h, --help        help for demote
      --json        Output result as a single JSON object
      --no-commit   Skip the auto-commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
