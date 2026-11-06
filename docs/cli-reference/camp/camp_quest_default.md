---
title: "camp quest default"
linkTitle: "camp quest default"
description: "Resolve or create an open default quest"
---

## camp quest default

Resolve or create an open default quest

### Synopsis

Return the current open fallback quest, creating a fresh default when
previous defaults are paused, completed, or archived. Existing quests and their
workspaces stay unchanged. The new default has a distinct ID and is reused by
later calls, including concurrent calls. Merely naming a quest "default" does
not make it the fallback.

This command does not commit or open an editor. Read-only callers should use
camp quest list --json --no-scaffold instead.

Examples:
  camp quest default
  camp quest default --json

```
camp quest default [flags]
```

### Options

```
  -h, --help   help for default
      --json   Output the resolved quest and whether it was created
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp
