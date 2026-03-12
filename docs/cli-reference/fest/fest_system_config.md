## fest system config

Manage fest configuration settings

### Synopsis

Interactive TUI for managing fest configuration.

Navigate to a setting to edit it. Changes are saved immediately.
Configuration is stored in ~/.config/fest/config.json.

Use arrow keys or j/k to navigate, Enter to select, Esc to exit.

```
fest system config [flags]
```

### Examples

```
  fest system config           # Open configuration TUI
  fest system config --show    # Display current configuration
```

### Options

```
  -h, --help   help for config
      --show   display current configuration as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest system](fest_system.md)	 - Manage fest tool configuration and templates

