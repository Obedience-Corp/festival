---
title: "camp idea explore"
linkTitle: "camp idea explore"
description: "Interactive idea explorer"
---

## camp idea explore

Interactive idea explorer

### Synopsis

Launch the interactive Idea Explorer TUI.

The explorer provides a full-screen interface for browsing,
filtering, and managing ideas with keyboard shortcuts.

NAVIGATION
  j/↓           Move down
  k/↑           Move up
  g             Go to top (preview)
  G             Go to bottom (preview)
  Enter/Space   Select/expand group
  Tab           Switch focus (list/preview)

ACTIONS
  e             Edit in $EDITOR
  o             Open with system handler
  O             Reveal in file manager
  n             New idea
  p             Promote to next status
  a             Archive idea
  d             Delete idea
  m             Move idea to status

GATHER (Multi-Select)
  Space         Toggle selection / enter gather mode
  ga            Gather selected ideas
  Escape        Exit multi-select mode

FILTERS
  /             Search ideas (fuzzy)
  t             Filter by type
  s             Filter by status
  c             Filter by concept
  C             Clear concept filter
  Escape        Clear filter/cancel

VIEW
  v             Toggle preview pane
  ?             Show help overlay
  q             Quit explorer

Examples:
  camp idea explore          Launch the idea explorer

```
camp idea explore [flags]
```

### Options

```
  -h, --help   help for explore
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas
