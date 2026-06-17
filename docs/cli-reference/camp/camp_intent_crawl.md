---
title: "camp intent crawl"
linkTitle: "camp intent crawl"
description: "Interactive intent triage"
---

## camp intent crawl

Interactive intent triage

### Synopsis

Walk live intents one at a time and decide their fate.

Default scope is the working set: inbox, ready, and active. Each candidate is
shown with a compact preview. For each one you can keep, move to another
status, skip, or quit. Moves to dungeon statuses require a reason.

Existing dungeon intents are not crawl candidates. Use 'camp intent move' to
restore them explicitly.

Examples:
  camp intent crawl
  camp intent crawl --status inbox --limit 25
  camp intent crawl --status ready --status active --sort priority
  camp intent crawl --no-commit

```
camp intent crawl [flags]
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

* [camp intent](../camp_intent/)	 - Manage campaign intents
