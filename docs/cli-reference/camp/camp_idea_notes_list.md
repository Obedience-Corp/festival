---
title: "camp idea notes list"
linkTitle: "camp idea notes list"
description: "List notes across folders"
---

## camp idea notes list

List notes across folders

### Synopsis

List notes in the note store, newest first by creation time.

Notes in the notes root and every folder, including meetings, are listed.
Archived notes are listed only with --folder archived. --folder matches one
folder exactly, without its subfolders; use "." for the notes root.

"camp idea list --status notes" returns the same notes.

Examples:
  camp idea notes list                          All notes except archived
  camp idea notes list --folder reading         Notes directly in notes/reading/
  camp idea notes list --folder .               Notes in the notes root only
  camp idea notes list --json                   Machine-readable note list

```
camp idea notes list [flags]
```

### Options

```
      --folder string   Only list notes directly in this folder under notes/ ("." for the root)
  -h, --help            help for list
      --json            emit a structured JSON result
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea notes](../camp_idea_notes/)	 - Manage the note store (list, folders, moves, meetings)
