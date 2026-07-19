---
title: "camp detach"
linkTitle: "camp detach"
description: "Remove the current campaign's attachment binding"
---

## camp detach

Remove the current campaign's attachment binding

### Synopsis

Remove the current campaign's binding from the .camp attachment marker.

Refuses on linked-project markers; use 'camp project unlink' for those.
The user-managed symlink (if any) is not modified. If run outside any campaign,
the entire attachment marker is removed.

On an attachment shared by several campaigns this removes only the current
campaign's binding; the others keep resolving. Detaching the campaign that a
bare cd into the shared target resolved to shifts that fallback to the next
remaining campaign.

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

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
