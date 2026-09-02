---
title: "camp triage review"
linkTitle: "camp triage review"
description: "Render the review documents for the active run"
---

## camp triage review

Render the review documents for the active run

### Synopsis

Render TRIAGE_REVIEW.md and PRIORITIES.md for the active run.

Both documents are output, not input. Verdicts are recorded with
camp triage approve; re-rendering replaces the files, so an edit made in them
is lost rather than honored. Each carries that statement at the top.

Every row in the run appears exactly once across the review's lanes, including
rows nobody has proposed anything for. A document that quietly omitted them
could be approved without the operator ever seeing what it left out.

Rendering is pure: the same run data always produces the same bytes, so
re-rendering an unchanged run is a no-op diff.

On a terminal this opens the lane-first review flow after rendering: lanes
first, then rows, with terminal actions confirming individually. Use
--render-only to render without opening it. Off a terminal the flow never
opens, so scripts and CI get the documents and nothing that waits for input.

```
camp triage review [flags]
```

### Options

```
  -h, --help          help for review
      --json          Output result as a single JSON object
      --render-only   Render the documents without opening the interactive review flow
      --run string    Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
