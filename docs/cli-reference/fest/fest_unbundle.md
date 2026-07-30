---
title: "fest unbundle"
linkTitle: "fest unbundle"
description: "Unbundle a .festival archive into a directory"
---

## fest unbundle

Unbundle a .festival archive into a directory

### Synopsis

Extract a Festival Bundle into a live directory.

Does NOT run, promote, or activate the festival. Use fest ritual run or normal
fest workflow separately after unbundle if execution is desired.

Optional --validate runs in-process festival validation on the destination
(this binary's validator, not a PATH-installed fest). Validation diagnostics
go to stderr so --json still emits a single JSON document on stdout.

```
fest unbundle [path.festival] [flags]
```

### Options

```
  -d, --dest string          destination directory (required)
      --force                allow non-empty destination
  -h, --help                 help for unbundle
      --json                 print info.json on stdout
      --no-received-record   skip .bundles/received
      --no-verify            skip content-hash verification
      --validate             run in-process fest validate on destination after unbundle
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
