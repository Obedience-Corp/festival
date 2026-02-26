## fest config add

Add a configuration repository

### Synopsis

Add a configuration repository from a git URL or local path.

For git repos, the repository will be cloned to ~/.config/fest/config-repos/<name>.
For local paths, a symlink will be created instead.

```
fest config add <name> <source> [flags]
```

### Examples

```
  fest config add myconfig https://github.com/user/fest-config
  fest config add local /path/to/my/config
  fest config add work git@github.com:company/fest-templates.git
```

### Options

```
  -h, --help   help for add
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest config](fest_config.md)	 - Manage fest configuration repositories

