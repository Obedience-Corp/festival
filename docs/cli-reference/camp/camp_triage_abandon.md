---
title: "camp triage abandon"
linkTitle: "camp triage abandon"
description: "Close the active triage run without applying it"
---

## camp triage abandon

Close the active triage run without applying it

### Synopsis

Close the active triage run without applying it.

Nothing is deleted. The run keeps its snapshot, its evidence, and every verdict
recorded so far; only its phase changes, which frees the active slot so a new
run can start. An abandoned run is still readable, and still the record of what
was decided before it was set aside.

A reason is optional but worth giving: it is what explains the abandonment to
whoever reads the run later.

```
camp triage abandon [flags]
```

### Options

```
  -h, --help            help for abandon
      --json            Output result as a single JSON object
      --reason string   Why the run is being abandoned
      --run string      Abandon a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session
