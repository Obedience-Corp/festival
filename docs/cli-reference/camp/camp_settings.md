---
title: "camp settings"
linkTitle: "camp settings"
description: "Manage camp configuration"
---

## camp settings

Manage camp configuration

### Synopsis

Interactive menu for managing camp configuration.

Today, this command edits global user preferences in
~/.obey/campaign/config.json.

Campaign-local settings still live in files under .campaign/, and the
"Local Settings" menu is currently a scaffold rather than a full editor.
See docs/campaign-settings-files.md in the camp repository for the current
file layout.

```
camp settings [flags]
```

### Examples

```
  camp settings   # Edit global editor/theme preferences
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
