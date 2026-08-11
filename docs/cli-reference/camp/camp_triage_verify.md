---
title: "camp triage verify"
linkTitle: "camp triage verify"
description: "Prove the campaign matches the approved decisions"
---

## camp triage verify

Prove the campaign matches the approved decisions

### Synopsis

Check every applied row against a fresh discovery pass.

Apply without proof is just hope. Verify re-walks the campaign and compares
what it finds against what each receipt says happened: a parked workitem should
carry that stage, a retired one should no longer be discoverable outside the
dungeon, a split's successors should all exist.

It reads receipts, not the plan. The plan is what was intended; the receipts
are what actually ran, and only the second one can be checked against reality.

An unexplained mismatch exits 1. That is the whole signal: the campaign is not
in the state the approved decisions said it would be. A mismatch someone has
already accounted for carries an explanation and does not fail the run.

A clean verification moves the run to verified and writes verification.json
with a rendered VERIFICATION.md beside it.

```
camp triage verify [flags]
```

### Options

```
  -h, --help         help for verify
      --json         Output result as a single JSON object
      --run string   Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session
