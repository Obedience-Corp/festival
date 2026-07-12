---
title: "camp event"
linkTitle: "camp event"
description: "Record and inspect campaign ledger events"
---

## camp event

Record and inspect campaign ledger events

### Synopsis

Record and inspect campaign event-ledger entries.

The ledger is the append-only trail of high-intent actions across a campaign.
Most events are captured automatically by state-changing camp/fest commands;
'camp event add' is the explicit escape hatch for actions that never touch git.

### Options

```
  -h, --help   help for event
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp event add](../camp_event_add/)	 - Record an explicit campaign ledger event
