---
title: "camp triage apply"
linkTitle: "camp triage apply"
description: "Execute the approved verdicts of the active run"
---

## camp triage apply

Execute the approved verdicts of the active run

### Synopsis

Execute approved verdicts through camp's own workitem commands.

Apply refreshes first, every time. A verdict rests on facts that may have moved
since it was recorded, and applying over a stale one is the failure this whole
command exists to prevent. Rows the refresh did not return fresh or moved are
refused and listed; re-judge them and approve again.

Nothing here moves a directory itself. Attention changes go through the same
priority store camp workitem stage writes, and promotions run the same function
camp workitem promote runs, so a triage apply and a hand-typed command cannot
diverge.

Every action appends a receipt: what ran, how long it took, what it produced,
the commit it made, and the command that reverses it. The undo is derived from
where the workitem actually landed, not from where the plan expected it to.

A failure stops the pass. Rows after it stay pending rather than being applied
against a campaign that is no longer in the state the plan was compiled for.
Re-running continues from the first row without an applied receipt, so an
interrupted apply is resumed rather than restarted.

--dry-run prints the whole plan, including rows that are blocked, and changes
nothing. It does not require freshness, so it is safe to read at any time.

```
camp triage apply [flags]
```

### Options

```
      --dry-run      Print the plan and change nothing
      --force        Apply terminal actions whose anchors could not be re-checked
  -h, --help         help for apply
      --json         Output result as a single JSON object
      --run string   Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session
