## fest index validate

Validate festival index against filesystem

### Synopsis

Validate that the festival index matches the actual filesystem structure.

Reports:
- Entries in index that don't exist on disk (missing)
- Files on disk that aren't in the index (extra)
- Missing goal files (warnings)

```
fest index validate [festival-path] [flags]
```

### Options

```
  -h, --help           help for validate
  -i, --index string   Path to index file (default: .festival/index.json)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest index](fest_index.md)	 - Manage festival indices

