---
title: "camp artifacts"
linkTitle: "camp artifacts"
description: "Manage declared artifact roots (.campaign/artifacts.yaml)"
---

## camp artifacts

Manage declared artifact roots (.campaign/artifacts.yaml)

### Synopsis

Manage the campaign's declared artifact roots: directories of heavy non-git
payloads (media, renders, datasets) that 'camp sync --from <machine>' moves
between your machines with rsync instead of git.

The declaration file (.campaign/artifacts.yaml) is committed, so every
machine knows what belongs to the campaign. Declared roots should be
gitignored: a root that is also git-tracked would make the same bytes both
git content and artifact content. Manifests and per-peer sync snapshots are
machine-local derived state under .campaign/cache (gitignored).

### Examples

```
  camp artifacts list
  camp artifacts add media/renders
  camp artifacts add datasets --policy on-demand
  camp artifacts remove media/renders
  camp artifacts manifest media/renders
```

### Options

```
  -h, --help   help for artifacts
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp artifacts add](../camp_artifacts_add/)	 - Declare an artifact root
* [camp artifacts list](../camp_artifacts_list/)	 - List declared artifact roots
* [camp artifacts manifest](../camp_artifacts_manifest/)	 - Print a declared root's manifest as JSON
* [camp artifacts remove](../camp_artifacts_remove/)	 - Remove an artifact root declaration
* [camp artifacts resolve](../camp_artifacts_resolve/)	 - Resolve an artifact conflict kept by no-clobber protection
