---
title: "camp project link"
linkTitle: "camp project link"
description: "Link an existing local project into a camp"
---

## camp project link

Link an existing local project into a camp

### Synopsis

Link an existing local directory into a camp.

If path is omitted, camp links the current working directory.

If you're already inside a camp, camp uses that camp automatically.
If you're outside a camp in an interactive terminal, camp opens a picker
so you can choose a registered camp. Use --campaign <name-or-id> to skip
the picker or for non-interactive scripts.

This creates a symlink at projects/<name> and writes .camp with the selected
camp ID.

Examples:
  camp project link                          # Link current directory
  camp project link ~/code/my-project        # Link another directory
  camp project link --campaign platform      # Link current directory to a specific camp
  camp project link ~/code/my-project --campaign platform
  camp project link ~/code/my-project --name backend

```
camp project link [path] [flags]
```

### Options

```
  -c, --campaign string   Target camp by name or ID; defaults to current camp or interactive picker
  -h, --help              help for link
  -n, --name string       Override project name (defaults to directory name)
      --no-commit         Skip automatic git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
