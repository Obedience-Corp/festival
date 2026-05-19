---
title: "camp stage"
linkTitle: "camp stage"
description: "Stage changes in the campaign root"
---

## camp stage

Stage changes in the campaign root

### Synopsis

Stage changes in the campaign root directory without committing.

Runs the same auto-staging logic as 'camp commit' (including stale lock
file cleanup) but stops before creating a commit, so you can use a
different commit strategy (interactive 'git commit --patch', a GUI
client, signing flow, etc.).

At the campaign root, submodule ref changes (projects/*) are excluded
from staging by default to prevent accidental ref conflicts across
machines. Use --include-refs to stage them explicitly.

Use --sub to stage in the submodule detected from your current directory.
Use -p/--project to stage in a specific project (e.g., -p projects/camp).

Examples:
  camp stage
  camp stage --include-refs
  camp stage --sub
  camp stage -p projects/camp

```
camp stage [flags]
```

### Options

```
  -h, --help             help for stage
      --include-refs     Include submodule ref changes when staging at campaign root
  -p, --project string   Operate on a specific project/submodule path
      --sub              Operate on the submodule detected from current directory
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
