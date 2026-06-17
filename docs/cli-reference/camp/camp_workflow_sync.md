---
title: "camp workflow sync"
linkTitle: "camp workflow sync"
description: "Repair auto-fixable doctor findings"
---

## camp workflow sync

Repair auto-fixable doctor findings

### Synopsis

Repair auto-fixable workflow findings reported by workflow doctor.

The command plans changes to campaign.yaml, .campaign/settings/jumps.yaml, and
the navigation cache for stale shortcuts, missing concepts, duplicate shortcut
keys, and cache drift. By default it reports the planned actions only; pass
--apply to write changes. Use --json for machine-readable plans and applied
actions.

```
camp workflow sync [flags]
```

### Options

```
      --apply   perform writes (default: report only)
  -h, --help    help for sync
      --json    emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workflow](../camp_workflow/)	 - Manage workflow collections
