---
title: "camp workitem links"
linkTitle: "camp workitem links"
description: "List workitem links"
---

## camp workitem links

List workitem links

### Synopsis

List workitem links recorded in the camp link registry.

The command reads .campaign/workitems/links.yaml and prints every link, or only
links for the supplied workitem selector. Use this to audit which projects,
festivals, worktrees, or paths are attached to a workitem. Use --json for
machine-readable link lists.

```
camp workitem links [selector] [flags]
```

### Options

```
  -h, --help   help for links
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active camp work items
