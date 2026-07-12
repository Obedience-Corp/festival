---
title: "camp audit repair"
linkTitle: "camp audit repair"
description: "Attribute a commit to a workitem or festival after the fact"
---

## camp audit repair

Attribute a commit to a workitem or festival after the fact

### Synopsis

Attribute an already-landed commit to a workitem or festival by appending a
repaired event. This never rewrites git history; it only records the attribution
in the ledger (D004). Use it to claim an untagged commit surfaced by
'camp audit doctor' for a piece of work.

```
camp audit repair --sha <sha> (--workitem <id> | --festival <id>) --why <reason> [flags]
```

### Options

```
      --festival string   festival to attribute the commit to
  -h, --help              help for repair
      --repo string       evidence repo label (default: campaign-root)
      --sha string        commit sha to attribute (required)
      --why string        reason for the attribution (required)
      --workitem string   workitem to attribute the commit to
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp audit](../camp_audit/)	 - Inspect the campaign audit trail
