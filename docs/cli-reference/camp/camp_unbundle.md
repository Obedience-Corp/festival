---
title: "camp unbundle"
linkTitle: "camp unbundle"
description: "Unbundle a .festival archive into a directory"
---

## camp unbundle

Unbundle a .festival archive into a directory

### Synopsis

Extract a Festival Bundle into a live work-unit directory. Does not execute festivals or rituals.

```
camp unbundle [flags]
```

### Options

```
  -d, --dest string          destination directory (required)
      --force                allow non-empty destination
  -h, --help                 help for unbundle
      --json                 emit info.json as JSON on stdout
      --no-received-record   do not write .bundles/received
      --no-verify            skip bundle.id content-hash verification
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
