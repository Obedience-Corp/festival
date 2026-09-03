---
title: "camp pin"
linkTitle: "camp pin"
description: "Pin a directory"
---

## camp pin

Pin a directory

### Synopsis

Pin a directory for quick navigation with 'camp go <name>' or 'cgo <name>'.

If path is omitted, the current working directory is used.

```
camp pin <name> [path] [flags]
```

### Examples

```
  camp pin code                        # Pin current directory as "code"
  camp pin design workflow/design/my-project
  camp go code                         # Jump to a pin by name
  cgo design                           # Shell jump to a pin
```

### Options

```
  -h, --help   help for pin
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
