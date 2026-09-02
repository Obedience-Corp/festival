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
camp. Local settings live in .campaign/settings/local.json and apply
only to the current camp; a local theme override wins over the global
theme while you are inside that camp.

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
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp settings get](../camp_settings_get/)	 - Print camp settings
* [camp settings set](../camp_settings_set/)	 - Set a camp setting
