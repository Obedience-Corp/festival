---
title: "camp settings get"
linkTitle: "camp settings get"
description: "Print camp settings"
---

## camp settings get

Print camp settings

### Synopsis

Print camp settings non-interactively.

With no key, prints all settings including the effective theme. With a key,
prints just that value.

Keys:
  global.theme           Color theme in ~/.obey/campaign/config.json
  global.editor          Preferred editor
  global.campaigns_dir   Where camp create places new campaigns
  global.verbose         Verbose output
  global.no_color        Disable colored output
  local.theme_override   Campaign-local theme override (requires a campaign)

```
camp settings get [key] [flags]
```

### Examples

```
  camp settings get
  camp settings get global.theme
  camp settings get --json
```

### Options

```
  -h, --help   help for get
      --json   emit a structured JSON result
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.json)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp settings](../camp_settings/)	 - Manage camp configuration
