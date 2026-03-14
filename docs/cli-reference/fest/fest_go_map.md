---
title: "fest go map"
linkTitle: "fest go map"
description: "Create a navigation shortcut"
---

## fest go map

Create a navigation shortcut

### Synopsis

Create a shortcut for quick navigation using fgo.

If path is omitted, the current directory is used.
Shortcut names must be alphanumeric (with underscores), 1-20 characters.

Usage with fgo:
  fgo -<name>    Navigate to the shortcut

```
fest go map <name> [path] [flags]
```

### Examples

```
  fest go map n                   # Create shortcut 'n' to current directory
  fest go map api /path/to/api    # Create shortcut 'api' to specific path

  # Then navigate with:
  fgo -n      # Navigate to notes
  fgo -api    # Navigate to API directory
```

### Options

```
  -h, --help   help for map
      --json   output in JSON format
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest go](../fest_go/)	 - Navigate to festivals/ - use 'fgo' after shell-init setup
