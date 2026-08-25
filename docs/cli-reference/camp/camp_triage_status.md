---
title: "camp triage status"
linkTitle: "camp triage status"
description: "Show where the active triage run stands"
---

## camp triage status

Show where the active triage run stands

### Synopsis

Show where the active triage run stands.

Status reports the session, not the campaign. It reads the run's own recorded
data and never walks the filesystem, so it is instant and keeps meaning even
after the campaign moves underneath the run. Comparing a run against the
current state of the campaign is what camp triage refresh does.

Exits 0 when there is no run: a campaign that has not triaged yet is a state,
not an error.

```
camp triage status [flags]
```

### Options

```
  -h, --help         help for status
      --json         Output result as a single JSON object
      --run string   Inspect a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session
