---
title: "camp triage init"
linkTitle: "camp triage init"
description: "Scaffold .campaign/triage with the profile and guide"
---

## camp triage init

Scaffold .campaign/triage with the profile and guide

### Synopsis

Write .campaign/triage/ if it is not there yet.

The profile ships with every key written out and commented, not as an empty
file inheriting invisible defaults: you should be able to read what triage
will do before you run it, and change it by deleting a line.

Nothing is ever overwritten. A file you have edited is reported as diverged
and left exactly as you wrote it: the profile is meant to be edited, so
divergence is information rather than a problem.

camp triage start does this for you on first use, so this command is only
needed when you want the files before starting a run.

```
camp triage init [flags]
```

### Options

```
  -h, --help   help for init
      --json   Output result as a single JSON object
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp triage](../camp_triage/)	 - Review the campaign's workitems in a recorded session
