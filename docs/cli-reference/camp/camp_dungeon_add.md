---
title: "camp dungeon add"
linkTitle: "camp dungeon add"
description: "Initialize dungeon structure"
---

## camp dungeon add

Initialize dungeon structure

### Synopsis

Initialize the dungeon directory with documentation and structure.

Creates the dungeon directory with:
  - OBEY.md: Documentation explaining the dungeon's purpose
  - completed/: Successfully finished work
  - archived/: Preserved for history, truly done
  - someday/: Low priority, might revisit

Initialize the dungeon directory structure directly, without requiring
workflow setup (no .workflow.yaml, active/, or ready/ directories).
Useful when you only need a dungeon for idea capture or temporary holding.

This operation is idempotent - running it multiple times is safe.
Use --force to overwrite existing files.

```
camp dungeon add [flags]
```

### Examples

```
  camp dungeon add          Initialize dungeon (skip existing files)
  camp dungeon add --force  Overwrite existing documentation
```

### Options

```
  -f, --force   Overwrite existing files
  -h, --help    help for add
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp dungeon](../camp_dungeon/)	 - Manage the camp dungeon
