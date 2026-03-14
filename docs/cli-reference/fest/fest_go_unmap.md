---
title: "fest go unmap"
linkTitle: "fest go unmap"
description: "Remove a navigation shortcut"
---

## fest go unmap

Remove a navigation shortcut

### Synopsis

Remove a previously created navigation shortcut.

```
fest go unmap <name> [flags]
```

### Examples

```
  fest go unmap n     # Remove shortcut 'n'
  fest go unmap api   # Remove shortcut 'api'
```

### Options

```
  -h, --help   help for unmap
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
