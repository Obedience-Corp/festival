---
title: "camp idea notes mv"
linkTitle: "camp idea notes mv"
description: "Move a note into a folder"
---

## camp idea notes mv

Move a note into a folder

### Synopsis

Move a note into a folder under notes/. Use "" or "." for the notes root.

The destination folder must already exist (create it with folders add first).

Examples:
  camp idea notes mv nested-paper-20260101-000001 reading/papers
  camp idea notes mv nested-paper-20260101-000001 .

```
camp idea notes mv <note-id> <folder> [flags]
```

### Options

```
  -h, --help   help for mv
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea notes](../camp_idea_notes/)	 - Manage the note store (folders, moves, meetings)
