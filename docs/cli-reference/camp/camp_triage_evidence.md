---
title: "camp triage evidence"
linkTitle: "camp triage evidence"
description: "Submit or draft evidence for a row"
---

## camp triage evidence

Submit or draft evidence for a row

### Synopsis

Submit or draft the evidence record for one row of the active run.

Evidence is advisory data, never authority. Camp validates the record against
the triage/v1alpha1 schema and stores it; what it means for the row is decided
by a proposal and then by a human approving one.

Commands:
  set        Store a record from a file, or mark a row decided without one
  template   Print a record with the facts camp already knows filled in

```
camp triage evidence [flags]
```

### Options

```
  -h, --help   help for evidence
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
* [camp triage evidence set](../camp_triage_evidence_set/)	 - Store an evidence record for a row
* [camp triage evidence template](../camp_triage_evidence_template/)	 - Print an evidence record with the known facts filled in
