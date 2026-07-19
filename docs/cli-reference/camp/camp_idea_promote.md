---
title: "camp idea promote"
linkTitle: "camp idea promote"
description: "Promote an idea through the pipeline"
---

## camp idea promote

Promote an idea through the pipeline

### Synopsis

Promote an idea to the next pipeline stage.

TARGETS:
  ready      Move from inbox to ready (reviewed/enriched)
  festival   Move from ready to active + create festival (default)
  design     Move from ready to active + create design doc

The idea moves to active status when promoted to festival or design,
because work is just beginning. Use --force to bypass status checks.

Examples:
  camp idea promote add-dark                       Promote ready → festival
  camp idea promote add-dark --target design       Promote ready → design doc
  camp idea promote add-dark --target ready         Promote inbox → ready
  camp idea promote add-dark --force                Force promote from any status

```
camp idea promote <id> [flags]
```

### Options

```
      --dry-run         Preview promotion without making changes
      --force           Promote even if not in expected status
  -h, --help            help for promote
      --no-commit       Don't create a git commit
      --target string   Promote target: ready, festival, design (default "festival")
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas
