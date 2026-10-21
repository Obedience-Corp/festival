---
title: "camp quest unlink"
linkTitle: "camp quest unlink"
description: "Remove a linked artifact from a quest"
---

## camp quest unlink

Remove a linked artifact from a quest

### Synopsis

Remove the association between a camp artifact and a quest.

The path must match exactly as it was linked (camp-root-relative).

Examples:
  camp quest unlink myquest .campaign/intents/inbox/some-intent.md
  camp quest unlink myquest projects/camp

```
camp quest unlink <quest> <path> [flags]
```

### Options

```
  -h, --help        help for unlink
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp quest](../camp_quest/)	 - Manage working contexts within a camp
