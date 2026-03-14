---
title: "fest config theme set"
linkTitle: "fest config theme set"
description: "Set the TUI theme"
---

## fest config theme set

Set the TUI theme

### Synopsis

Set the TUI color theme.

Available themes:
  adaptive      Auto-detect light/dark terminal (default)
  light         Optimized for light backgrounds
  dark          Optimized for dark backgrounds
  high-contrast Pure white + bright colors (works on any background)

```
fest config theme set <theme> [flags]
```

### Examples

```
  fest config theme set high-contrast
  fest config theme set dark
```

### Options

```
  -h, --help   help for set
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest config theme](../fest_config_theme/)	 - Manage TUI color theme
