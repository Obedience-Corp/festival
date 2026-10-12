---
title: "camp dungeon explore"
linkTitle: "camp dungeon explore"
description: "Browse finished work across every dungeon"
---

## camp dungeon explore

Browse finished work across every dungeon

### Synopsis

Browse finished work across every dungeon in this camp.

The feed is newest day first. Each row shows the work, the day it was put in
the dungeon, and which dungeon it came from. Festivals with a replay show that
replay on the focused row. The opening lens is finished work: completed and
done.

Keys in the feed:

  j/k, up/down      move
  ctrl+u/d          move half a page
  enter             read the item
  g                 jump the shell to the item; needs shell integration
  [ ], left/right   previous or next dungeon
  s                 next status lens
  /                 filter by text; enter applies, esc cancels
  space             play or pause the replay
  y                 copy the item path
  r                 rescan the camp
  ?                 show or close the full key list
  q, esc, ctrl+c    quit

Keys in the reader:

  j/k, up/down      scroll, or move through a listing
  ctrl+u/d          scroll half a page
  enter             open the selected document
  g                 jump the shell to the item
  y                 copy the document path
  esc, q            back to the feed

Replays draw in Kitty, Ghostty, WezTerm, and iTerm. The automatic choice is
off inside an editor's terminal (Neovim, Vim, Emacs) and in any terminal it
does not recognize; --images kitty or --images iterm forces a protocol there.
Inside tmux, screen, or zellij no replay is drawn, whatever --images says:
an image written there does not reach the terminal. With NO_COLOR set or
--no-color given, output is plain and no replay is drawn, whatever --images
says.

  camp dungeon explore
  camp dungeon explore --status archived
  camp dungeon explore --dungeon Festivals --query FA0024
  camp dungeon explore --json --since 2026-09-01

A pipe, or --json, prints the same index and does not open the feed.

--status takes a lens or the name of a status directory. A directory named
like a lens that means something else (finished, all) is selected with a
trailing slash: --status all/.

```
camp dungeon explore [flags]
```

### Options

```
      --dungeon string   Dungeon lens: all, a label, or a camp-relative dungeon path (default "all")
  -h, --help             help for explore
      --images string    Replay rendering: auto, kitty, iterm, or off; always off with NO_COLOR or --no-color, and inside tmux, screen, or zellij (default "auto")
      --json             Print the feed as JSON
      --no-media         Do not draw replays
      --query string     Case-insensitive substring matched against title, id, summary, dungeon, and path
      --since string     Include items put in the dungeon on or after this YYYY-MM-DD date
      --status string    Status lens: finished, completed, done, archived, someday, killed, holding, all, or a status directory name; a trailing slash (all/) always means the directory (default "finished")
      --until string     Include items put in the dungeon on or before this YYYY-MM-DD date
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp dungeon](../camp_dungeon/)	 - Manage the camp dungeon
