---
title: "camp triage priorities"
linkTitle: "camp triage priorities"
description: "Print the priorities brief for the active run"
---

## camp triage priorities

Print the priorities brief for the active run

### Synopsis

Print the priorities brief: what to work on, derived from the run's verdicts.

This is the artifact that keeps working after the session ends. The run holds
the source of truth; --export writes a rendered copy to the path the profile's
outputs.priorities_export names, so the brief lives where you already look.

The export overwrites rather than versioning. Versioned copies would recreate
the stale-priorities-document problem triage exists to end; history is git's
job. When the profile leaves the export path empty, --export reports that it
did nothing rather than failing.

```
camp triage priorities [flags]
```

### Options

```
      --export       Also write a copy to the profile's outputs.priorities_export path
  -h, --help         help for priorities
      --json         Output result as a single JSON object
      --run string   Use a specific run id instead of the latest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the camp's workitems in a recorded session
