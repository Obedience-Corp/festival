---
title: "camp triage refresh"
linkTitle: "camp triage refresh"
description: "Re-check the active run against the world"
---

## camp triage refresh

Re-check the active run against the world

### Synopsis

Re-check every row against a fresh discovery pass and its evidence anchors.

Verdicts expire. A row judged an hour ago rested on facts (a file's contents, a
workitem's stage, a festival's status), and refresh is what notices when one of
them moved. Each row comes back in one of five classes:

  fresh    identity resolves and every anchor still matches; the verdict stands
  moved    the item is at a new path or stage; the row is re-keyed and the
           verdict stands, because identity survives moves
  changed  an anchor observes a different value; the verdict goes stale and the
           row returns to the judgment queue
  gone     the item is no longer discoverable outside dungeons; the verdict goes
           stale and the row is flagged: someone likely finished it elsewhere
  new      discovered but absent from the snapshot; appended and queued

Every row prints the reason for its class, naming the anchor or the location
that decided it.

Anchors that need the network are recorded unchecked rather than assumed
current, and the summary counts them separately: not knowing is reported as not
knowing.

Refresh only records. It retires verdicts, re-keys rows, and appends new ones;
it never moves a workitem. That is camp triage apply, which refuses any row this
command did not return fresh or moved.

```
camp triage refresh [flags]
```

### Options

```
  -h, --help         help for refresh
      --json         Output result as a single JSON object
      --run string   Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
