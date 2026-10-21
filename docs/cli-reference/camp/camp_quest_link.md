---
title: "camp quest link"
linkTitle: "camp quest link"
description: "Link a camp artifact to a quest"
---

## camp quest link

Link a camp artifact to a quest

### Synopsis

Associate a camp artifact (intent, design, festival, project, document)
with a quest for traceability.

The link type is auto-detected from the path:
  .campaign/intents/ → intent
  workflow/design/   → design
  workflow/explore/  → explore
  festivals/         → festival
  projects/          → project
  (other)            → document

Use --type to override auto-detection.

Examples:
  camp quest link myquest .campaign/intents/inbox/some-intent.md
  camp quest link myquest projects/camp
  camp quest link myquest docs/spec.md --type spec

```
camp quest link <quest> <path> [flags]
```

### Options

```
  -h, --help          help for link
      --no-commit     Don't create a git commit
      --type string   Override auto-detected link type
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp
