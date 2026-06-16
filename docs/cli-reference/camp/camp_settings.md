---
title: "camp settings"
linkTitle: "camp settings"
description: "Manage camp configuration"
---

## camp settings

Manage camp configuration

### Synopsis

Interactive menu for managing camp configuration.

Global settings live in ~/.obey/campaign/config.json and apply to every
campaign. Local settings live in .campaign/settings/local.json and apply
only to the current campaign; a local theme override wins over the global
theme while you are inside that campaign.

For non-interactive access, use 'camp settings get' and
'camp settings set'. See docs/campaign-settings-files.md in the camp
repository for the file layout.

```
camp settings [flags]
```

### Examples

```
  camp settings                              # Interactive settings menu
  camp settings get                          # Print all settings
  camp settings set global.theme dark        # Set the global theme
  camp settings set local.theme_override light
```

### Options

```
  -h, --help   help for settings
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp settings get](../camp_settings_get/)	 - Print camp settings
* [camp settings set](../camp_settings_set/)	 - Set a camp setting
