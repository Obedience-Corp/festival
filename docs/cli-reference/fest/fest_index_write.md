---
title: "fest index write"
linkTitle: "fest index write"
description: "Generate festival index"
---

## fest index write

Generate festival index

### Synopsis

Generate a festival index from the filesystem structure.

The index is written to .festival/index.json within the festival directory.
Use --output to write to a different location.

```
fest index write [festival-path] [flags]
```

### Options

```
  -h, --help            help for write
  -o, --output string   Output path (default: .festival/index.json)
      --pretty          Pretty print JSON output (default true)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest index](../fest_index/)	 - Manage festival indices
