---
title: "fest config sync"
linkTitle: "fest config sync"
description: "Sync configuration repository"
---

## fest config sync

Sync configuration repository

### Synopsis

Sync a configuration repository (git pull for git repos).

If no name is provided, syncs all configured repos.

```
fest config sync [name] [flags]
```

### Examples

```
  fest config sync myconfig
  fest config sync  # syncs all repos
```

### Options

```
  -h, --help   help for sync
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
