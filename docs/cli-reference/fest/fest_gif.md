---
title: "fest gif"
linkTitle: "fest gif"
description: "Render a festival's execution as a GIF or MP4"
---

## fest gif

Render a festival's execution as a GIF or MP4

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

Use --mp4 to write an H.264 video for a vertical feed instead of a GIF. The
picture is fitted inside 1080x1920 and padded with the replay background, at
30 fps, with a silent audio track. This encodes the replay frames directly
and needs ffmpeg on PATH. -o with a .mp4 name selects the same export.
--mp4 cannot be combined with --embed. Completion still writes the GIF.

Promoting or setting a festival to completed does this automatically before
the status change is committed. Use --embed to refresh or retry that replay.

Every recorded change gets its own beat, in the order fest recorded it.
Nothing is merged or skipped. At default speed a beat holds 2 seconds,
shrinking to no less than 1 second once a festival has many changes, so a
long festival makes a long replay instead of losing steps. Row backgrounds
stay steady. Rejections and hook results get extra reading time.
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
  fest gif --mp4                    # 1080x1920 H.264 video (needs ffmpeg)
  fest gif -o docs/replay.mp4       # same export, chosen by file name
  fest gif --embed                  # save and embed the replay in the overview
  fest gif --speed 2                # twice as fast
  fest gif --speed 0.5              # half speed, easier to follow
```

### Options

```
      --embed             save festival-replay.gif in the festival and embed it in FESTIVAL_OVERVIEW.md
      --festival string   festival selector (name or ID) from within a camp
  -h, --help              help for gif
      --mp4               write a 1080x1920 H.264 MP4 for a vertical feed (needs ffmpeg)
  -o, --out string        output file (default ./<festival>.gif, or .mp4 with --mp4)
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
