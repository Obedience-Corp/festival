## camp project remove

Remove a project from campaign

### Synopsis

Remove a project from the campaign.

By default, this only removes the project from git submodule tracking.
The project files remain in place for you to handle manually.

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
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects

