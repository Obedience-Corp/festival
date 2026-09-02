---
title: "camp project unlink"
linkTitle: "camp project unlink"
description: "Unlink a linked project from a camp"
---

## camp project unlink

Unlink a linked project from a camp

### Synopsis

Remove a linked project symlink from a camp without touching the
external workspace contents.

If name is omitted, the current linked project is inferred from the working
directory.

Use this for linked workspaces added with 'camp project link'. This command
removes the symlink entry from projects/ and cleans up the linked repo's local
.camp marker when it belongs to the selected camp.

If you're already inside a camp, that camp is used by default.
Outside a camp, use --campaign <name-or-id> or a bare --campaign to
pick a registered target camp interactively.

Examples:
  camp project unlink
  camp project unlink my-project
  camp project unlink my-project --campaign platform
  camp project unlink --campaign platform
  camp project unlink my-project --campaign
  camp project unlink my-project --dry-run

```
camp project unlink [name] [flags]
```

### Options

```
  -c, --campaign string   Target camp by name or ID; omit value to pick interactively
      --dry-run           Show what would be done without making changes
  -h, --help              help for unlink
      --no-commit         Skip automatic git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
