---
title: "camp workflow show"
linkTitle: "camp workflow show"
description: "Show a workflow collection's config and recent workitems"
---

## camp workflow show

Show a workflow collection's config and recent workitems

### Synopsis

Show configuration and recent workitems for a workflow collection.

The command reads camp configuration plus the workflow/<type>/ directory,
then prints the collection path, shortcut state, concept state, and recent
.workitem-backed items. Use --json for machine-readable collection details and
recent workitem data.

```
camp workflow show <type> [flags]
```

### Options

```
  -h, --help   help for show
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workflow](../camp_workflow/)	 - Manage workflow collections
