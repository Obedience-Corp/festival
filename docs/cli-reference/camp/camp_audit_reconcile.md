---
title: "camp audit reconcile"
linkTitle: "camp audit reconcile"
description: "Fill ledger gaps from state files (opt-in write)"
---

## camp audit reconcile

Fill ledger gaps from state files (opt-in write)

### Synopsis

Derive the events implied by campaign state files (intent statuses and
festival status histories), diff them against the ledger, and report the gaps -
facts the ledger does not yet capture. This covers users who never commit at all.

By default this is a dry run. Pass --apply to append the missing facts as
reconciled events (idempotent: reconciled ids are content-derived, so re-running
does not duplicate).

```
camp audit reconcile [flags]
```

### Options

```
      --apply   append the missing facts as reconciled events
  -h, --help    help for reconcile
      --json    emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp audit](../camp_audit/)	 - Inspect the campaign audit trail
