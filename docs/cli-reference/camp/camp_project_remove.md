---
title: "camp project remove"
linkTitle: "camp project remove"
description: "Remove a project from campaign"
---

## camp project remove

Remove a project from campaign

### Synopsis

Remove a project from the campaign.

By default, this only removes the project from git submodule tracking.
The project directory is removed from the working tree by git rm. Pass --delete
to also remove any worktree directories managed by camp.

For linked projects, prefer 'camp project unlink'. Linked projects are
machine-local symlinks and are never deleted through this command.

Use --delete to also remove all project files. This is destructive
and requires confirmation unless --force is also specified.

Examples:
  camp project remove api-service           # Unregister submodule only
  camp project remove api-service --delete  # Also delete files (confirms)
  camp project remove api-service --delete --force  # Delete without confirmation
  camp project remove api-service --dry-run # Show what would be done

```
camp project remove <name> [flags]
```

### Options

```
  -d, --delete      Also delete project files (destructive)
      --dry-run     Show what would be done without making changes
  -f, --force       Skip confirmation prompts
  -h, --help        help for remove
      --no-commit   Skip automatic git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage campaign projects
