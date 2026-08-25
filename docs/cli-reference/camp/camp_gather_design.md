---
title: "camp gather design"
linkTitle: "camp gather design"
description: "Combine selected design workitems into one gathered package"
---

## camp gather design

Combine selected design workitems into one gathered package

### Synopsis

Combine selected design workitems into one gathered package.

Sources are always chosen explicitly: pass 2 or more selectors (stable id,
key, path, or directory slug), or run with no arguments in a terminal for an
interactive picker. There is no automatic discovery mode.

The gather process:
  1. Create workflow/design/<slug>/ with a fresh .workitem and a
     generated README.md indexing the gathered packages
  2. Move each source directory inside the new package (git history follows
     the rename)
  3. Stamp gathered_into/gathered_at on each source .workitem
  4. Migrate manual priority state and re-home workitem links
  5. Commit the move (unless --no-commit)

Moved sources stop appearing as separate workitems because discovery only
scans the top level of workflow/design/.

Examples:
  camp gather design pkg-one pkg-two --title "Unified topic"
  camp gather design pkg-one pkg-two pkg-three -t "Unified topic" --slug unified-topic
  camp gather design                # interactive picker (TTY only)
  camp gather design pkg-one pkg-two -t "Unified topic" --dry-run

```
camp gather design [selectors...] [flags]
```

### Options

```
      --dry-run        Print the planned gather, change nothing
      --force          Gather sources even when one has an active workflow run
  -h, --help           help for design
      --json           Output result as a single JSON object
      --no-commit      Skip the auto-commit
      --slug string    Directory slug override (default: derived from title)
  -t, --title string   Title for the gathered workitem (required unless prompted interactively)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp gather](../camp_gather/)	 - Gather related work into unified items
