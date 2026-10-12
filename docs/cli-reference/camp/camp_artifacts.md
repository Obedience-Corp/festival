---
title: "camp artifacts"
linkTitle: "camp artifacts"
description: "Explore artifact files and manage declared roots"
---

## camp artifacts

Explore artifact files and manage declared roots

### Synopsis

Open the artifact explorer: search files, open them with Enter, copy paths
with y, or go to their folder with g (requires camp shell-init).
The explorer lists files outside git in declared roots, including ignored
files. Tracked files are excluded. --plain and --json work without a terminal.

Manage the camp's declared artifact roots: directories of heavy non-git
payloads (media, renders, datasets) that 'camp sync --from <machine>' moves
between your machines with rsync instead of git.

The declaration file (.campaign/artifacts.yaml) is committed, so every
machine knows what belongs to the camp. Declared roots should be
gitignored: a root that is also git-tracked would make the same bytes both
git content and artifact content. Manifests and per-peer sync snapshots are
machine-local derived state under .campaign/cache (gitignored).

```
camp artifacts [flags]
```

### Examples

```
  camp artifacts              # interactive explorer
  camp artifacts --plain      # file list
  camp artifacts --json       # file inventory for scripts
  camp artifacts list         # declared roots
  camp artifacts add media/renders
  camp artifacts add datasets --policy on-demand
  camp artifacts remove media/renders
  camp artifacts manifest media/renders
```

### Options

```
  -h, --help    help for artifacts
      --json    Print artifact files as JSON
      --plain   Print artifact files instead of opening the explorer
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp artifacts add](../camp_artifacts_add/)	 - Declare an artifact root
* [camp artifacts list](../camp_artifacts_list/)	 - List declared artifact roots
* [camp artifacts manifest](../camp_artifacts_manifest/)	 - Print a declared root's manifest as JSON
* [camp artifacts remove](../camp_artifacts_remove/)	 - Remove an artifact root declaration
* [camp artifacts resolve](../camp_artifacts_resolve/)	 - Resolve an artifact conflict kept by no-clobber protection
