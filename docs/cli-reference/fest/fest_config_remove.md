---
title: "fest config remove"
linkTitle: "fest config remove"
description: "Remove a configuration repository"
---

## fest config remove

Remove a configuration repository

### Synopsis

Remove a configuration repository.

For git repos, this removes the cloned directory.
For local symlinks, this only removes the symlink (not the original directory).

```
fest config remove <name> [flags]
```

### Examples

```
  fest config remove myconfig
```

### Options

```
      --force   skip confirmation
  -h, --help    help for remove
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
