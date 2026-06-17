---
title: "camp workflow doctor"
linkTitle: "camp workflow doctor"
description: "Report workflow surface inconsistencies"
---

## camp workflow doctor

Report workflow surface inconsistencies

### Synopsis

Report inconsistencies between workflow directories and campaign configuration.

The command reads campaign.yaml, .campaign/settings/jumps.yaml, workflow/
directories, and the navigation cache to find missing concepts, stale
shortcuts, duplicate shortcut keys, and cache drift. Use --json for
machine-readable findings and stable finding codes.

```
camp workflow doctor [flags]
```

### Options

```
  -h, --help   help for doctor
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workflow](../camp_workflow/)	 - Manage workflow collections
