---
title: "camp fresh show-workflow"
linkTitle: "camp fresh show-workflow"
description: "Show the fresh cycle and configured follow-up steps"
---

## camp fresh show-workflow

Show the fresh cycle and configured follow-up steps

### Synopsis

Show the ordered steps camp fresh will use, including disabled steps
and the follow-up commands resolved for a project.

With no project name, the global defaults are shown. Pass a project name to
include its branch, pruning, and follow-up overrides.

```
camp fresh show-workflow [project-name] [flags]
```

### Options

```
  -h, --help   help for show-workflow
```

### Options inherited from parent commands

```
  -b, --branch string   Branch to create after syncing (overrides config)
  -n, --dry-run         Preview without making changes
      --no-branch       Skip branch creation even if configured
      --no-color        disable colored output
      --no-follow-up    Skip configured follow-up command workflows
      --no-prune        Skip pruning merged branches
      --no-push         Skip pushing the new branch upstream
```

### SEE ALSO

* [camp fresh](../camp_fresh/)	 - Post-merge branch cycling: sync to default branch and optionally create a new working branch
