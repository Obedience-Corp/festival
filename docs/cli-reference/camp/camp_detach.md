---
title: "camp detach"
linkTitle: "camp detach"
description: "Remove the attachment marker from a directory"
---

## camp detach

Remove the attachment marker from a directory

### Synopsis

Remove the .camp attachment marker from the target directory.

Refuses on linked-project markers; use 'camp project unlink' for those.
The user-managed symlink (if any) is not modified.

Examples:
  camp detach ai_docs/examples/external-repo
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

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
