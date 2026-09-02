---
title: "camp settings set"
linkTitle: "camp settings set"
description: "Set a camp setting"
---

## camp settings set

Set a camp setting

### Synopsis

Set a camp setting non-interactively.

Accepts the same keys as 'camp settings get'. Theme values are one of
adaptive, light, dark, or high-contrast. Boolean values accept true/false.
Setting local.theme_override to 'inherit' clears the override; local.* keys
require running inside a camp.

```
camp settings set <key> <value> [flags]
```

### Examples

```
  camp settings set global.theme dark
  camp settings set global.verbose true
  camp settings set local.theme_override light
  camp settings set local.theme_override inherit
```

### Options

```
  -h, --help   help for set
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp settings](../camp_settings/)	 - Manage camp configuration
