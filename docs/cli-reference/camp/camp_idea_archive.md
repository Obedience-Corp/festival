---
title: "camp idea archive"
linkTitle: "camp idea archive"
description: "Archive an idea"
---

## camp idea archive

Archive an idea

### Synopsis

Archive an idea by moving it to dungeon/archived.

This is a convenience command equivalent to:
  camp idea move <id> archived --reason "..."

Dungeon moves require a reason and append a decision record to the idea body.
Use 'camp idea move <id> inbox' to un-archive if needed.

Examples:
  camp idea archive add-dark --reason "superseded by broader initiative"
  camp idea archive 20260119-153412 --reason "preserve as reference"

```
camp idea archive <id> [flags]
```

### Options

```
  -h, --help            help for archive
      --no-commit       Don't create a git commit
      --reason string   Reason for archiving (required)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas
