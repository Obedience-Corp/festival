## camp shortcuts

List all available shortcuts

### Synopsis

List all navigation and command shortcuts from .campaign/campaign.yaml.

Navigation shortcuts (path-based):
  These shortcuts jump to directories within the campaign.
  Usage: camp go <shortcut>

Command shortcuts (command-based):
  These shortcuts execute commands from specified directories.
  Usage: camp run <shortcut> [args...]

Default shortcuts are added when you run 'camp init'.
You can customize shortcuts by editing .campaign/campaign.yaml.

```
camp shortcuts [flags]
```

### Examples

```
  camp shortcuts              # List all shortcuts
  camp go api                 # Use navigation shortcut
  camp run build              # Use command shortcut
```

### Options

```
  -h, --help   help for shortcuts
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp shortcuts add](camp_shortcuts_add.md)	 - Add a shortcut (campaign-level or project sub-shortcut)
* [camp shortcuts list](camp_shortcuts_list.md)	 - List shortcuts for a specific project
* [camp shortcuts remove](camp_shortcuts_remove.md)	 - Remove a shortcut (campaign-level or project sub-shortcut)

