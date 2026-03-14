---
title: "fest config theme"
linkTitle: "fest config theme"
description: "Manage TUI color theme"
---

## fest config theme

Manage TUI color theme

### Synopsis

Manage the TUI color theme for fest commands.

Available themes:
  adaptive      Auto-detect light/dark terminal (default)
  light         Optimized for light backgrounds
  dark          Optimized for dark backgrounds
  high-contrast Pure white + bright colors (works on any background)

Use 'fest config theme test' to preview all themes on your terminal.

### Options

```
  -h, --help   help for theme
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest config](../fest_config/)	 - Manage fest configuration repositories
* [fest config theme set](../fest_config_theme_set/)	 - Set the TUI theme
* [fest config theme show](../fest_config_theme_show/)	 - Show current theme setting
* [fest config theme test](../fest_config_theme_test/)	 - Preview all themes side by side
