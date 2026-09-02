---
title: "camp workitem doctor"
linkTitle: "camp workitem doctor"
description: "Report link-registry health issues"
---

## camp workitem doctor

Report link-registry health issues

### Synopsis

Report health issues in the camp workitem link registry.

The command reads .campaign/workitems/links.yaml, scans .workitem metadata on
disk, and checks current-workitem and priority stores for stale or inconsistent
references. Use --fix to apply auto-repairs for supported findings, including
rewriting projects: entries whose path git recorded as a project rename. Use
--json for machine-readable findings and stable finding codes.

```
camp workitem doctor [flags]
```

### Options

```
      --fix    auto-repair findings tagged auto_fixable
  -h, --help   help for doctor
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active camp work items
