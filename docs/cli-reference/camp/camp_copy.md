---
title: "camp copy"
linkTitle: "camp copy"
description: "Copy a file or directory within the camp"
---

## camp copy

Copy a file or directory within the camp

### Synopsis

Copy a file or directory within the current camp.

Paths are resolved relative to the current directory, matching standard
'cp' behavior and tab completion.

Use @ prefix for camp shortcuts (e.g., @p/fest, @f/active/).
Available shortcuts are defined in camp config.

If the destination is an existing directory or ends with '/', the source
is placed inside it with the same basename. Directories are copied
recursively.

```
camp copy <src> <dest> [flags]
```

### Examples

```
  camp copy myfile.md ../docs/
  camp cp @f/active/my-fest/OVERVIEW.md @d/
  camp cp @w/design/active/ @w/explore/backup/
```

### Options

```
  -f, --force   Overwrite destination without prompting
  -h, --help    help for copy
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
