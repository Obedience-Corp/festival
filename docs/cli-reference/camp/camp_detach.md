---
title: "camp detach"
linkTitle: "camp detach"
description: "Remove the current camp's attachment binding"
---

## camp detach

Remove the current camp's attachment binding

### Synopsis

Remove the current camp's binding from the .camp attachment marker.

Refuses on linked-project markers; use 'camp project unlink' for those.
The user-managed symlink (if any) is not modified. If run outside any camp,
the entire attachment marker is removed.

On an attachment shared by several camps this removes only the current
camp's binding; the others keep resolving. Detaching the camp that a
bare cd into the shared target resolved to shifts that fallback to the next
remaining camp.

Examples:
  camp detach docs/examples/external-repo
  camp detach ~/scratch/notes-link

```
camp detach <path> [flags]
```

### Options

```
  -h, --help   help for detach
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
