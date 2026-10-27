---
title: "camp skills status"
linkTitle: "camp skills status"
description: "Show skill bundle projection links and shipped bundle states"
---

## camp skills status

Show skill bundle projection links and shipped bundle states

### Synopsis

Show projection status for camp skill bundles across tool targets, and
how each bundle camp ships compares with this camp version.

Reports whether each tool's skills directory has projected entries from
.campaign/skills/, is partially projected, missing, broken, or blocked.

Each shipped bundle is reported as current, outdated (unchanged since an older
camp wrote it), modified (changed locally), missing, unknown (differs with no
record of what camp shipped), or symlink (differs through a symlink, which camp
never replaces). The record is .campaign/skills/.shipped.yaml; for a file it
does not cover, a lone camp init or camp repair commit with no change since in
git also counts as outdated. 'camp skills update' refreshes outdated and missing bundles and
preserves modified and unknown ones unless --force is given.

Examples:
  camp skills status          Show projection states in table format
  camp skills status --json   Machine-readable JSON output

```
camp skills status [flags]
```

### Options

```
  -h, --help     help for status
      --json     Output as JSON
      --strict   Return non-zero exit code when links need attention (for CI)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp skills](../camp_skills/)	 - Manage camp skill bundles and their directory links
