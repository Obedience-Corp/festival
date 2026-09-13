---
title: "Festival Replays"
weight: 75
description: "Create and share animated GIF replays, automatically embedded when a festival is completed."
---

`fest gif` turns a festival's recorded progress into an animated GIF. Tasks,
workflow steps, gates, judge verdicts, and hook runs appear in the order they
were recorded. The final frame matches the current festival tree.

## Completed festivals

When a festival moves to completed through `fest promote`,
`fest promote --dungeon completed`, or `fest status set completed`, Fest:

1. Moves the festival to its completed directory and updates its status.
2. Creates `festival-replay.gif` alongside `FESTIVAL_OVERVIEW.md`.
3. Adds a relative image link in a managed **Execution replay** section, creating
   the overview if needed.
4. Includes the GIF and overview in the normal completion commit.

`--no-commit`, when permitted by the workspace policy, leaves these files on disk
without committing them. Moving a festival to ready, active, archived, or someday
does not generate a replay. Reopening and completing a festival refreshes its GIF
and keeps a single generated section; the rest of the overview is preserved.

Share the GIF as a file, attach it to a PR, or share the whole festival directory.
Keep the GIF beside the overview so its relative image link continues to work.

## Generate or refresh a replay manually

```sh
fest gif                           # Write ./<festival>.gif
fest gif my-festival -o replay.gif  # Choose a festival and output filename
fest gif --festival MF0001          # Select by ID from within a camp
fest gif --speed 2                  # Double playback speed
fest gif --speed 0.5                # Half playback speed
fest gif --embed                    # Refresh the festival's GIF and overview
fest gif --festival MF0001 --embed  # Add a replay to an older completed festival
```

`--embed` always writes inside the selected festival, even when run from one of
its phases or from elsewhere in the camp. It cannot be combined with `--out`.
It replaces only the section between `<!-- fest:replay:start -->` and
`<!-- fest:replay:end -->`; notes and frontmatter outside it remain unchanged.

## Missing history and recovery

A festival without a progress log still gets a GIF based on its current tree.
Only recorded events can show the actual execution order; missing history cannot
be reconstructed. Forced completion also reflects the actual recorded state,
so incomplete work can remain visible in the final frame.

A replay failure does not undo completion. The command reports a warning on
stderr; `--json` includes a `replay.warning` field while keeping `success: true`
for the completed transition. On success, `replay.path` identifies the GIF.
Fix the reported problem and run `fest gif --embed` inside the completed festival.
Commit the refreshed files if you want to save the repair in version control.

A pre-existing `festival-replay.gif` without a managed overview section is
preserved. Move that file aside before retrying. An incomplete or duplicated
managed section must have its markers repaired before regeneration. Overview
symlinks are preserved and reported rather than replaced.

GIF and overview writes use temporary files. A failed or cancelled render does
not publish a partial GIF or insert a new broken image link.
