---
title: "camp triage queue"
linkTitle: "camp triage queue"
description: "List rows awaiting judgment"
---

## camp triage queue

List rows awaiting judgment

### Synopsis

List the rows of the active run that are still awaiting judgment.

This is the dispatch surface for whatever drives the evidence phase. Each row
carries its batch, its type policy (how much evidence to gather, which model
class to read it with), and the schema version of the record to produce. An
orchestrating agent reads the queue, fans out however it likes, and submits
results with camp triage evidence set and camp triage propose.

Camp never calls a model. The routing block is advisory: camp passes it
through verbatim and does not enforce it.

Roles:
  evidence     the row has no evidence record yet
  synthesis    evidence exists, but no proposal does

Rows that already hold a proposal are not queued: what they need next is a
human approving them, not more judgment. Carried rows are not queued either -
their verdicts came forward precisely so nobody re-reads them.

```
camp triage queue [flags]
```

### Options

```
  -h, --help          help for queue
      --json          Output result as a single JSON object
      --role string   Only rows awaiting this role: evidence or synthesis
      --run string    Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
