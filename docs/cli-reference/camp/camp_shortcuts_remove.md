## camp shortcuts remove

Remove a shortcut (campaign-level or project sub-shortcut)

### Synopsis

Remove a shortcut.

Campaign-level shortcut (1 arg):
  Usage: camp shortcuts remove <name>

Project sub-shortcut (2 args):
  Usage: camp shortcuts remove <project> <name>

```
camp shortcuts remove <name> or <project> <name> [flags]
```

### Examples

```
  camp shortcuts remove api                           Remove campaign shortcut
  camp shortcuts remove festival-methodology cli      Remove project sub-shortcut
```

### Options

```
  -h, --help   help for remove
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp shortcuts](camp_shortcuts.md)	 - List all available shortcuts

