---
title: "camp quest item add"
linkTitle: "camp quest item add"
description: "Add a checklist item to a quest"
---

## camp quest item add

Add a checklist item to a quest

```
camp quest item add <quest> <title> [flags]
```

### Options

```
  -h, --help              help for add
      --json              Emit JSON output
      --no-commit         Don't create a git commit
      --notes string      Short note (depth belongs in the workitem)
      --rank int          Explicit sort rank (default: appended after the last item)
      --status string     Initial status: open|doing|done|dropped (default open)
      --workitem string   Link a workitem by id, key, path, or ref
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest item](../camp_quest_item/)	 - Manage checklist items on a quest
