---
title: "camp workitem promote"
linkTitle: "camp workitem promote"
description: "Promote a workitem: festival, doc, rail, dungeon"
---

## camp workitem promote

Promote a workitem: festival, doc, rail, dungeon

### Synopsis

Promote the workitem identified by [id], by cwd, or by the current pointer.

TARGETS:
  festival    Create a festival from the workitem and shelve the source
  doc         Copy the workitem doc into docs/ and shelve the source
  ready       Move the workitem onto the festival rail at festivals/ready
  active      Move the workitem onto the festival rail at festivals/active
  completed   Move the workitem to its local dungeon/completed
  archived    Move the workitem to its local dungeon/archived
  someday     Move the workitem to its local dungeon/someday

The rail is forward-only: root -> ready -> active. A workitem already on a
stage cannot move backward, and moving one out of a dungeon is a restore
rather than a promote.

```
camp workitem promote [id] --target <target> [flags]
```

### Options

```
      --dest string     Destination path under docs/ for the doc target (must stay within docs/)
      --dry-run         Print the planned action, change nothing
      --force           Skip readiness checks (e.g. empty doc)
      --goal string     Festival goal override (default: first paragraph of the workitem doc)
  -h, --help            help for promote
      --json            Output result as a single JSON object
      --keep            On festival/doc, do not move the source workitem to the dungeon
      --no-commit       Skip the auto-commit
      --target string   Promotion target: festival, doc, ready, active, completed, archived, someday
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
