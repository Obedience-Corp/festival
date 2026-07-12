---
title: "camp audit backfill"
linkTitle: "camp audit backfill"
description: "Derive a source:backfill event stream from history (opt-in write)"
---

## camp audit backfill

Derive a source:backfill event stream from history (opt-in write)

### Synopsis

Derive ledger events from a campaign's existing history - tagged commits across
linked repos, intent frontmatter, and festival status histories - so a pre-ledger
campaign (or the pre-ledger history of this one) renders on the same timeline as
new activity.

Backfill is optional and never required. It is idempotent and live-wins: a fact
already captured live or by a prior backfill is skipped, so consecutive runs
produce zero new events. Dry-run by default; --apply writes the source:backfill
events into the standard shard layout.

```
camp audit backfill [flags]
```

### Options

```
      --apply   write the derived source:backfill events into the ledger
  -h, --help    help for backfill
      --json    emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp audit](../camp_audit/)	 - Inspect the campaign audit trail
