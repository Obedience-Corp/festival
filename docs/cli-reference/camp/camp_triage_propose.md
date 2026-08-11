---
title: "camp triage propose"
linkTitle: "camp triage propose"
description: "Propose a disposition for a row"
---

## camp triage propose

Propose a disposition for a row

### Synopsis

Propose what should happen to one row.

The disposition is a label from the row's type vocabulary; camp resolves it to
the action it will actually perform and records both. That indirection is what
lets a campaign rename its labels without triage learning a new mutation.

A proposal is not a decision. Terminal actions - dungeon moves and splits -
always require a human to approve them, and the result says so.

One proposal is live per row, but nothing is overwritten: proposing again
retires the previous one with a superseded event and records the new one, so
the stream keeps the whole argument rather than only where it landed.

The rationale can come from a file or from --summary for a one-liner:
  camp triage propose <id> --disposition completed --summary "shipped in #239"
  camp triage propose <id> --disposition consolidate --file rationale.json

```
camp triage propose <stable-id> [flags]
```

### Options

```
      --confidence string    Confidence in the proposal when using --summary: high, medium, or low (default "medium")
      --disposition string   Disposition label from the row's type vocabulary
      --file string          Path to the rationale JSON ('-' for stdin)
  -h, --help                 help for propose
      --json                 Output result as a single JSON object
      --run string           Use a specific run id instead of the latest
      --summary string       One-line rationale, instead of --file
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session
