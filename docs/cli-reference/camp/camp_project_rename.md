---
title: "camp project rename"
linkTitle: "camp project rename"
description: "Rename a managed project"
---

## camp project rename

Rename a managed project

### Synopsis

Rename a managed project and migrate its active Camp references.

Supported projects are declared Git submodules, linked workspace symlinks,
and ordinary camp-owned directories tracked by the camp repository.
Dirty project checkouts and linked worktrees are preserved. Destination
collisions and unmanaged directories are rejected before mutation.

Camp never guesses that an upstream repository was renamed. Pass --remote-url
to change origin explicitly as part of the same transaction.

Examples:
  camp project rename api-old api
  camp project mv api-old api
  camp project rename obey-installer festival-installer \
    --remote-url git@github.com:Obedience-Corp/festival-installer.git
  camp project rename api-old api --dry-run --json

```
camp project rename <current> <new> [flags]
```

### Options

```
  -c, --campaign string     Target camp by name or ID; omit value to pick interactively
      --dry-run             Print the complete plan without writing
  -h, --help                help for rename
      --json                Output a versioned JSON plan or result
      --no-commit           Apply the rename without a camp commit
      --no-verify           Skip remote connectivity verification
      --remote-url string   Explicitly update the project's origin URL
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
