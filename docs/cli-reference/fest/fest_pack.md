---
title: "fest pack"
linkTitle: "fest pack"
description: "Pack a festival or ritual directory into a .festival bundle"
---

## fest pack

Pack a festival or ritual directory into a .festival bundle

### Synopsis

Pack a festival/ritual tree into a portable .festival ZIP.

Does not execute or promote the festival. Out-of-root file links are vendored
into .artifacts/; in-root links are left unchanged.

Works from any directory (global scope); source path is explicit.

```
fest pack [source-dir] [flags]
```

### Options

```
      --creator string   bundle.creator (default "fest")
  -h, --help             help for pack
      --json             print info.json on stdout
      --kind string      bundle kind (festival|ritual); inferred when empty
      --name string      bundle name
      --no-sent-record   skip .bundles/sent on source
  -o, --output string    output .festival path (required)
      --strict           fail if out-of-root links are missing
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
