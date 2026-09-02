---
title: "camp leverage reset"
linkTitle: "camp leverage reset"
description: "Clear all cached leverage data to allow full recomputation"
---

## camp leverage reset

Clear all cached leverage data to allow full recomputation

### Synopsis

Reset deletes cached snapshots and blame data so that leverage can
recompute from scratch.

Without flags, all project caches are removed. Use --project to clear
only a single project's data.

Examples:
  camp leverage reset                    Clear all cached data
  camp leverage reset --project camp     Clear only camp's cached data

```
camp leverage reset [flags]
```

### Options

```
  -h, --help             help for reset
      --no-commit        skip the automatic commit of .campaign/leverage data
  -p, --project string   clear snapshots for a single project
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp leverage](../camp_leverage/)	 - Compute leverage scores for the camp's projects
