---
title: "camp workitem convert"
linkTitle: "camp workitem convert"
description: "Move a workitem to another workflow type"
---

## camp workitem convert

Move a workitem to another workflow type

### Synopsis

Convert the workitem matched by <selector> from its current workflow
type root to --type, keeping the same basename. Identity is preserved: the
stable id, ref, and title do not change. The directory (or file) moves from
workflow/<old-type>/<name> to workflow/<new-type>/<name>, and the marker
(or file frontmatter) type field is updated to match.

References are repaired in the same commit as the move, using the same
rewrites as camp workitem rename:
  - relative markdown links pointing at the workitem are rewritten
  - the workitem link registry (links.yaml) key and any scope paths under the
    moved directory are updated
  - manual priority and attention-stage entries are re-keyed on disk

Festivals and intents are managed by their own tooling and cannot be converted
here. Workitems already in a dungeon cannot be converted; restore them first.
This is not a rename: the basename stays put. Use camp workitem rename to
change the name without changing type.

```
camp workitem convert <selector> [flags]
```

### Examples

```
  camp workitem convert camp-triage --type design
  camp workitem convert WI-36e2a6 --type design --json
  camp workitem convert explore-notes --type design --dry-run
```

### Options

```
      --dry-run       Print the planned conversion, change nothing
  -h, --help          help for convert
      --json          Output result as a single JSON object
      --no-commit     Skip the auto-commit
      --type string   Destination workflow type
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp workitem](../camp_workitem/)	 - View active campaign work items
