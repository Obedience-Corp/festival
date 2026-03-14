---
title: "fest system update"
linkTitle: "fest system update"
description: "System: Update fest methodology files from templates"
---

## fest system update

System: Update fest methodology files from templates

### Synopsis

Update the .festival/ methodology files from latest templates.

This is a SYSTEM command that updates fest's methodology files (templates,
documentation, agents) in your workspace - NOT your festival content.

It compares your .festival/ files with the latest templates and updates
only the files you haven't modified. For modified files, it will prompt you
for action unless --no-interactive is specified.

Your actual festivals (phases, sequences, tasks) are never modified by this command.

```
fest system update [path] [flags]
```

### Examples

```
  fest system update                  # Interactive update
  fest system update --dry-run        # Preview changes
  fest system update --no-interactive # Skip all modified files
  fest system update --backup         # Create backups before updating
```

### Options

```
      --backup           create backups before updating
      --diff             show diffs for modified files
      --dry-run          show what would be updated without making changes
      --force            update all files regardless of modifications
  -h, --help             help for update
      --interactive      prompt for each modified file (default true)
      --no-interactive   update only unchanged files, skip modified
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest system](../fest_system/)	 - Manage fest tool configuration and templates
