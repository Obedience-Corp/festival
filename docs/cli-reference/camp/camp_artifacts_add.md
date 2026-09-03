---
title: "camp artifacts add"
linkTitle: "camp artifacts add"
description: "Declare an artifact root"
---

## camp artifacts add

Declare an artifact root

### Synopsis

Declare a camp-relative directory as an artifact root.

Policy 'always' (default) syncs the root on every 'camp sync --from
<machine>'; 'on-demand' syncs it only when artifacts are requested
explicitly (--artifacts-only).

```
camp artifacts add <path> [flags]
```

### Options

```
      --dry-run         Report what declaring this root would cover; write nothing
  -h, --help            help for add
      --no-gitignore    Declare the root without adding its .gitignore rule
      --policy string   Sync policy: always (every peer sync) or on-demand (--artifacts-only) (default "always")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp artifacts](../camp_artifacts/)	 - Manage declared artifact roots (.campaign/artifacts.yaml)
