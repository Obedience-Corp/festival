---
title: "camp idea crawl"
linkTitle: "camp idea crawl"
description: "Interactive idea triage"
---

## camp idea crawl

Interactive idea triage

### Synopsis

Walk live ideas one at a time and decide their fate.

Default scope is the working set: inbox, ready, and active. Each candidate is
shown with a compact preview. For each one you can keep, move to another
status, skip, or quit. Moves to dungeon statuses require a reason.

Existing dungeon ideas are not crawl candidates. Use 'camp idea move' to
restore them explicitly.

Examples:
  camp idea crawl
  camp idea crawl --status inbox --limit 25
  camp idea crawl --status ready --status active --sort priority
  camp idea crawl --no-commit

```
camp idea crawl [flags]
```

### Options

```
  -h, --help             help for crawl
      --limit int        Stop after N candidates (0 = no limit)
      --no-commit        Apply moves and logs but do not auto-commit
      --sort string      Sort mode: stale, updated, created, priority, title (default "stale")
      --status strings   Restrict to live statuses (repeatable: inbox, ready, active)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas
