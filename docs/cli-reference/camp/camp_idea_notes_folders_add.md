---
title: "camp idea notes folders add"
linkTitle: "camp idea notes folders add"
description: "Create a note folder"
---

## camp idea notes folders add

Create a note folder

### Synopsis

Create a note folder under notes/ (parents created as needed).

Folder names must be lowercase kebab-case. Reserved names (archived, meetings)
are rejected at the notes root. A .gitkeep is written so empty folders survive git.

Examples:
  camp idea notes folders add reading
  camp idea notes folders add reading/papers

```
camp idea notes folders add <folder> [flags]
```

### Options

```
  -h, --help   help for add
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea notes folders](../camp_idea_notes_folders/)	 - List note folders
