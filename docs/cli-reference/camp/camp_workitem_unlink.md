---
title: "camp workitem unlink"
linkTitle: "camp workitem unlink"
description: "Remove workitem links"
---

## camp workitem unlink

Remove workitem links

### Synopsis

Remove workitem links from the campaign link registry.

The command updates .campaign/workitems/links.yaml by link id, workitem
selector, explicit path, or scope filter. Use --all when a selector matches
multiple links and every match should be removed. Use --json for
machine-readable details about the removed links.

```
camp workitem unlink [selector] [path] [flags]
```

### Options

```
      --all               remove every link matching the selector
      --festival string   festival scope filter
  -h, --help              help for unlink
      --id string         remove the link with this lnk_ id
      --json              emit a structured JSON result
      --project string    project scope filter
      --worktree string   worktree scope filter
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
