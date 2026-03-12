## fest go list

List navigation shortcuts and links

### Synopsis

Display all navigation shortcuts and festival-project links.

SHORTCUTS are user-defined with 'fest go map'.
LINKS are festival-project associations created with 'fest link'.

Use --interactive (-i) to select a destination with an interactive picker.
When used with shell integration (fgo list), this will navigate to the selected path.

```
fest go list [flags]
```

### Examples

```
  fest go list           # List all shortcuts and links
  fest go list --json    # Output in JSON format
  fest go list -i        # Interactive picker (with fgo: navigates to selection)
```

### Options

```
  -h, --help          help for list
  -i, --interactive   interactive picker mode
      --json          output in JSON format
      --print         accepted for shell integration compatibility
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest go](fest_go.md)	 - Navigate to festivals/ - use 'fgo' after shell-init setup

