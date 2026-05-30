---
title: "camp promote"
linkTitle: "camp promote"
description: "Promote the workitem at cwd to a dungeon status"
---

## camp promote

Promote the workitem at cwd to a dungeon status

### Synopsis

Promote the directory-style workitem containing the current working
directory to a named status. Status directories live under the workitem
type's local dungeon (workflow/<type>/dungeon/<status>/); outside the
dungeon a workitem is treated as active.

Run this from anywhere inside workflow/<type>/<slug>/. The workitem
boundary is detected from cwd. The status argument is the destination
directory name (e.g., completed, archived, someday) - no need to spell
out "dungeon/".

Examples:
  camp promote completed   Shelve the workitem to its local dungeon/completed
  camp promote archived    Move to dungeon/archived
  camp promote someday     Move to dungeon/someday

```
camp promote <status> [flags]
```

### Options

```
  -h, --help        help for promote
      --json        Output result as JSON
      --no-commit   Skip auto-commit after promotion
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
