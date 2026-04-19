---
title: "camp project link"
linkTitle: "camp project link"
description: "Link an existing local project into a campaign"
---

## camp project link

Link an existing local project into a campaign

### Synopsis

Link an existing local directory into a campaign.

If path is omitted, camp links the current working directory.

If you're already inside a campaign, camp uses that campaign automatically.
If you're outside a campaign in an interactive terminal, camp opens a picker
so you can choose a registered campaign. Use --campaign <name-or-id> to skip
the picker or for non-interactive scripts.

This creates a symlink at projects/<name> and writes .camp with the selected
campaign ID.

Examples:
  camp project link                          # Link current directory
  camp project link ~/code/my-project        # Link another directory
  camp project link --campaign platform      # Link current directory to a specific campaign
  camp project link ~/code/my-project --campaign platform
  camp project link ~/code/my-project --name backend

```
camp project link [path] [flags]
```

### Options

```
  -c, --campaign string   Target campaign by name or ID; defaults to current campaign or interactive picker
  -h, --help              help for link
  -n, --name string       Override project name (defaults to directory name)
      --no-commit         Skip automatic git commit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage campaign projects
