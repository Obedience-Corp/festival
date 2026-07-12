---
title: "camp audit doctor"
linkTitle: "camp audit doctor"
description: "Scan linked repos for unattributed commits (informational)"
---

## camp audit doctor

Scan linked repos for unattributed commits (informational)

### Synopsis

Scan the campaign root and every linked project repo, classifying each
commit as tagged, degraded, or untagged (no captured intent linkage).

Output is informational: untagged commits are surfaced, never scolded, and the
command exits 0 even when findings exist. Use --window to bound each repo to its
most recent N commits (default: full history).

```
camp audit doctor [flags]
```

### Options

```
  -h, --help         help for doctor
      --json         emit a structured JSON report
      --window int   scan only the most recent N commits per repo (0 = full history)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp audit](../camp_audit/)	 - Inspect the campaign audit trail
