---
title: "camp lifecycle set"
linkTitle: "camp lifecycle set"
description: "Set a camp's lifecycle status"
---

## camp lifecycle set

Set a camp's lifecycle status

### Synopsis

Transition a camp to one of: active, inactive, reference.

Any other value is rejected. Setting inactive or reference does not unregister
the camp.

```
camp lifecycle set <camp> <status> [flags]
```

### Examples

```
  camp lifecycle set old-project reference
```

### Options

```
  -h, --help   help for set
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp lifecycle](../camp_lifecycle/)	 - Manage camp lifecycle status
