---
title: "camp artifacts manifest"
linkTitle: "camp artifacts manifest"
description: "Print a declared root's manifest as JSON"
---

## camp artifacts manifest

Print a declared root's manifest as JSON

### Synopsis

Walk a declared artifact root and print its manifest (relative path, size,
mtime per file) as JSON. This is the same shape sync snapshots use, so it is
useful for scripting and for comparing roots across machines.

```
camp artifacts manifest <path> [flags]
```

### Options

```
  -h, --help   help for manifest
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp artifacts](../camp_artifacts/)	 - Manage declared artifact roots (.campaign/artifacts.yaml)
