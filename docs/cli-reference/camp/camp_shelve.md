---
title: "camp shelve"
linkTitle: "camp shelve"
description: "Shelve the workitem at cwd to a dungeon status"
---

## camp shelve

Shelve the workitem at cwd to a dungeon status

### Synopsis

Shelve the directory-style workitem containing the current working
directory to a named dungeon status. Status directories live under the
workitem type's local dungeon (workflow/<type>/dungeon/<status>/); outside
the dungeon a workitem is treated as active.

Run this from anywhere inside workflow/<type>/<slug>/. The workitem
boundary is detected from cwd. The status argument is the destination
directory name (e.g., completed, archived, someday) - no need to spell
out "dungeon/".

```
camp shelve <status> [flags]
```

### Examples

```
  camp shelve completed   Shelve the workitem to its local dungeon/completed
  camp shelve archived    Move to dungeon/archived
  camp shelve someday     Move to dungeon/someday
```

### Options

```
  -h, --help        help for shelve
      --json        Output result as JSON
      --no-commit   Skip auto-commit after shelving
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
