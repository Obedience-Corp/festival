---
title: "fest gif"
linkTitle: "fest gif"
description: "Render a festival's execution as an animated GIF"
---

## fest gif

Render a festival's execution as an animated GIF

### Synopsis

Render the festival tree as an animated GIF that replays its execution.
Each task, step, and gate changes state in the order fest recorded it, the
way fest watch shows it live. A gate waiting on the approval judge shows the
judge glyph and "Judge: waiting", then the verdict, including reject and
recheck loops. Each lifecycle hook run appears under the row it fired on. The
last frame matches fest show.

Works on any festival with a progress log, including completed festivals in
the dungeon. The festival can be the current directory, a name, a path, or a
--festival selector. The GIF is written to ./<festival>.gif unless --out is
given.
Use --embed to save festival-replay.gif inside the festival and add a relative
image link to FESTIVAL_OVERVIEW.md (creating the overview if needed). Repeating
--embed refreshes the replay without duplicating the link. --embed and --out
cannot be combined.

Promoting or setting a festival to completed does this automatically before
the status change is committed. Use --embed to refresh or retry that replay.

At default speed, related task changes are grouped by sequence and each
update holds for at least 2 seconds. Row backgrounds stay steady. Replays
target about a minute; distinct sequences and important outcomes can extend
that. Rejections and hook results get extra reading time.
Use --speed to play it faster or slower.

```
fest gif [festival] [flags]
```

### Examples

```
  fest gif                          # festival in the current directory
  fest gif my-festival              # by name, from anywhere in a camp
  fest gif festivals/.dungeon/completed/2026-01-01/my-festival   # by path
  fest gif --festival DM0001        # by selector
  fest gif -o docs/replay.gif       # choose the output file
  fest gif --embed                  # save and embed the replay in the overview
  fest gif --speed 2                # twice as fast
  fest gif --speed 0.5              # half speed, easier to follow
```

### Options

```
      --embed             save festival-replay.gif in the festival and embed it in FESTIVAL_OVERVIEW.md
      --festival string   festival selector (name or ID) from within a camp
  -h, --help              help for gif
  -o, --out string        output file (default ./<festival>.gif)
      --speed float       playback speed: 2 is twice as fast, 0.5 is half speed (default 1)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
