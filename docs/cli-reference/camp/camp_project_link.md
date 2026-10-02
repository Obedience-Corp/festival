---
title: "camp project link"
linkTitle: "camp project link"
description: "Link an existing local project into a camp"
---

## camp project link

Link an existing local project into a camp

### Synopsis

Link an existing local directory into a camp.

The folder stays where it is. Camp adds a shortcut at projects/<name>
and a .camp file in that folder. This is not a git submodule.

In a terminal, paste or type a path, or move through folders.
Enter links the folder. Tab opens a folder. Then name it, choose
the camp, and confirm before anything is written. Pass --yes,
or run the command without a terminal, to link immediately.

Inside a camp, that camp is already selected. Paste or type the
project folder, or move through the list. Outside a camp, the
screen asks which camp to use. --campaign <name-or-id> skips that
choice. A bare --campaign always asks.

Examples:
  camp project link
  camp project link ~/code/my-project
  camp project link ~/code/my-project --yes
  camp project link --campaign platform
  camp project link ~/code/my-project --name backend

```
camp project link [path] [flags]
```

### Options

```
  -c, --campaign string   Target camp by name or ID; defaults to current camp or interactive picker
  -h, --help              help for link
  -i, --interactive       Open the folder screen
  -n, --name string       Override project name (defaults to directory name)
      --no-commit         Skip automatic git commit
      --yes               Link immediately without the folder screen
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
