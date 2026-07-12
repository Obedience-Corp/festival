---
title: "camp audit"
linkTitle: "camp audit"
description: "Inspect the campaign audit trail"
---

## camp audit

Inspect the campaign audit trail

### Synopsis

Inspect the campaign audit trail.

'camp audit doctor' scans linked repos for commits with no captured intent
linkage and reports them informationally. Untagged commits are a normal mode
for wrapper-opt-out workflows, not a violation.

### Options

```
  -h, --help   help for audit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp audit backfill](../camp_audit_backfill/)	 - Derive a source:backfill event stream from history (opt-in write)
* [camp audit doctor](../camp_audit_doctor/)	 - Scan linked repos for unattributed commits (informational)
* [camp audit reconcile](../camp_audit_reconcile/)	 - Fill ledger gaps from state files (opt-in write)
* [camp audit repair](../camp_audit_repair/)	 - Attribute a commit to a workitem or festival after the fact
