---
title: "camp attach"
linkTitle: "camp attach"
description: "Attach an external directory to a camp"
---

## camp attach

Attach an external directory to a camp

### Synopsis

Attach a non-project directory to a camp by writing a .camp marker.

The user manages the symlink (if any). camp attach only writes the marker at
the resolved target so commands run from inside that directory can recover
camp context. Attachment markers may be shared by multiple camps;
running attach again from another camp adds that camp to the marker.

If the target is reached through a symlink, camp follows it once and writes
the marker at the final directory.

When several camps share one attachment, which camp a command resolves
depends on how the directory is reached: entering through a camp-local
symlink resolves that camp, while a bare cd into the shared target itself
resolves to the first camp it was attached to.

Camp selection:
  - inside a camp, omit --campaign to attach to the current camp
  - outside a camp in an interactive terminal, omit --campaign to pick
  - use a bare --campaign to force the picker even inside a camp
  - use --campaign <name-or-id> for scripts or to skip the picker

Examples:
  camp attach docs/examples/external-repo
  camp attach ~/scratch/notes-link
  camp attach ~/scratch/notes-link --campaign
  camp attach /abs/path/to/dir --campaign platform

```
camp attach <path> [flags]
```

### Options

```
  -c, --campaign string   Target camp by name or ID; omit value to pick interactively
      --force             Rewrite an existing attachment marker
  -h, --help              help for attach
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
