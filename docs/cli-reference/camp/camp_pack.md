---
title: "camp pack"
linkTitle: "camp pack"
description: "Pack a directory into a portable .festival bundle"
---

## camp pack

Pack a directory into a portable .festival bundle

### Synopsis

Pack a work-unit directory into a compressed .festival archive using the Festival Bundle format.

```
camp pack [flags]
```

### Options

```
      --creator string   bundle.creator identity (default "camp")
  -h, --help             help for pack
      --json             emit info.json as JSON on stdout
      --kind string      bundle kind (explore, design, intent, note, …); inferred from path when empty
      --name string      human-readable bundle name (default: directory name)
      --no-sent-record   do not write .bundles/sent on the source tree
  -o, --output string    output .festival path (required)
      --strict           fail if out-of-root linked files are missing
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
