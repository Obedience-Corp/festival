---
title: "camp triage approve"
linkTitle: "camp triage approve"
description: "Record verdicts on proposed dispositions"
---

## camp triage approve

Record verdicts on proposed dispositions

### Synopsis

Record your verdict on the proposals in the active run.

This is how a decision enters. The rendered documents are output, so editing
them records nothing; approval happens here and re-rendering reflects it.

Selectors:
  camp triage approve <id> [<id>...]     name rows explicitly
  camp triage approve --lane parked      every row in a lane
  camp triage approve --batch 2          every row in a review batch

Bulk selectors deliberately do not cover terminal rows: anything that retires
a workitem into the dungeon or splits it. Approving a batch is not meaningful
consent to each irreversible action inside it, so those rows are listed and
skipped, and approving one means naming it. When you do, the confirmation
echoes the exact command apply will run.

  --amend <disposition>   approve a different disposition than proposed,
                          revalidated against the row's own vocabulary
  --reject                record a refusal; the row returns to needing a
                          proposal
  --note <text>           attach a note to the verdicts

Re-approving a verdict that already stands is reported as unchanged rather
than written twice: the stream is an argument, not a log of keystrokes.

```
camp triage approve [stable-id...] [flags]
```

### Options

```
      --amend string   Approve a different disposition than the one proposed
      --batch int      Approve every non-terminal row in a review batch
  -h, --help           help for approve
      --json           Output result as a single JSON object
      --lane string    Approve every non-terminal row in a lane
      --note string    Note recorded with the verdicts
      --reject         Record a refusal instead of an approval
      --run string     Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
