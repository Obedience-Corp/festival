---
title: "fest config use"
linkTitle: "fest config use"
description: "Set active configuration repository"
---

## fest config use

Set active configuration repository

### Synopsis

Set a configuration repository as the active one.

The active config repo is symlinked at ~/.config/fest/active and its
contents are used for templates, policies, plugins, and extensions.

```
fest config use <name> [flags]
```

### Examples

```
  fest config use myconfig
  fest config use work
```

### Options

```
  -h, --help   help for use
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
