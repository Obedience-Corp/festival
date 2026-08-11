---
title: "camp triage evidence set"
linkTitle: "camp triage evidence set"
description: "Store an evidence record for a row"
---

## camp triage evidence set

Store an evidence record for a row

### Synopsis

Store the evidence record for one row.

The record is validated against the triage/v1alpha1 schema before anything is
written. A rejection lists every violated field with its allowed values, so one
submission produces one complete list of what to fix rather than a sequence of
one-at-a-time failures.

Storing is idempotent by content: resubmitting an identical record changes
nothing, so a driver that retries a batch does not churn the run.

--no-evidence records that the row was judged without a gathered record. That
is a real answer, not a missing one: it satisfies the same requirement a full
record does, while stating honestly that no reading was done.

```
camp triage evidence set <stable-id> [flags]
```

### Options

```
      --file string   Path to the evidence record JSON ('-' for stdin)
  -h, --help          help for set
      --json          Output result as a single JSON object
      --no-evidence   Record that the row was judged without a gathered record
      --run string    Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage evidence](../camp_triage_evidence/)	 - Submit or draft evidence for a row
