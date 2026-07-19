---
title: "camp idea rename"
linkTitle: "camp idea rename"
description: "Rename an idea"
---

## camp idea rename

Rename an idea

### Synopsis

Rename an idea: update its title and regenerate its human-readable
filename. The idea's stable id is preserved, so references and lookups survive
the rename.

Resolution is by exact id (run 'camp idea list' to copy one).

Examples:
  camp idea rename add-dark-mode-20260119-153412 "Add a dark mode toggle"

```
camp idea rename <id> <new title> [flags]
```

### Options

```
  -h, --help        help for rename
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage campaign ideas
