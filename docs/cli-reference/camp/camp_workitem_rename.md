---
title: "camp workitem rename"
linkTitle: "camp workitem rename"
description: "Rename a workitem and repair references"
---

## camp workitem rename

Rename a workitem and repair references

### Synopsis

Rename the workitem matched by <selector> so its directory (or file)
basename becomes <new-name>. Identity is preserved: the stable id, ref, title,
type, and lifecycle status do not change; only the path basename moves.

References are repaired in the same commit as the move:
  - relative markdown links pointing at the workitem are rewritten
  - the workitem link registry (links.yaml) key and any scope paths under the
    renamed directory are updated
  - manual priority and attention-stage entries are re-keyed on disk
  - the current-workitem pointer is updated when it referenced the old path key

Festivals and intents are managed by their own tooling and cannot be renamed
here. For file workitems, pass the full new filename; the original extension is
kept when omitted.

```
camp workitem rename <selector> <new-name> [flags]
```

### Options

```
      --dry-run     Print the planned rename, change nothing
  -h, --help        help for rename
      --json        Output result as a single JSON object
      --no-commit   Skip the auto-commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
