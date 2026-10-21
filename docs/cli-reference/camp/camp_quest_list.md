---
title: "camp quest list"
linkTitle: "camp quest list"
description: "List quests"
---

## camp quest list

List quests

### Synopsis

List quests in the current camp.

In a terminal, 'camp quest list' (with no flags) opens an interactive
browser that uses the same TUI components as 'camp list' (boxed frame,
status-grouped rows, collapsing help). Press j/k to move, y to copy the
quest path, f to cycle live / all / dungeon, and g or enter to jump to
the selected quest when shell integration is loaded:

  eval "$(camp shell-init zsh)"   # or bash / sh
  camp shell-init fish | source   # fish
  Invoke-Expression (& camp shell-init powershell | Out-String)   # PowerShell
  camp quest list                 # interactive browser; g cds into the quest

Piped or with --json it prints that format instead. --status/--all/--dungeon
print the filtered table. -i forces the browser (and still prints the table
when stdout is not a terminal).

```
camp quest list [flags]
```

### Options

```
      --all              Include dungeon quests
      --dungeon          Show only dungeon quests
  -h, --help             help for list
  -i, --interactive      Open the interactive quest browser (prints the table when stdout is not a terminal)
      --json             Emit JSON output
      --status strings   Filter by quest status
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp
