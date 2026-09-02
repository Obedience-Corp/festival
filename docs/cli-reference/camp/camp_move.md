---
title: "camp move"
linkTitle: "camp move"
description: "Move a file or directory within the camp"
---

## camp move

Move a file or directory within the camp

### Synopsis

Move a file or directory within the current camp.

Paths are resolved relative to the current directory, matching standard
'mv' behavior and tab completion.

Use @ prefix for camp shortcuts (e.g., @p/fest, @f/active/).
Available shortcuts are defined in camp config.

If the destination is an existing directory or ends with '/', the source
is placed inside it with the same basename.

```
camp move <src> <dest> [flags]
```

### Examples

```
  camp move mydir/ ../docs/mydir/
  camp mv @f/active/old-fest @f/completed/
  camp mv draft.md @w/design/
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for move
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
