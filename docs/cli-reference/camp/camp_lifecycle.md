---
title: "camp lifecycle"
linkTitle: "camp lifecycle"
description: "Manage camp lifecycle status"
---

## camp lifecycle

Manage camp lifecycle status

### Synopsis

Manage a camp's lifecycle status.

The status is one of a fixed set:
  active      in current use (default); shown in 'camp list'
  inactive    paused or shelved; hidden from default 'camp list'
  reference   preserved read-only context; hidden from default views

Setting inactive or reference does not unregister the camp; use
'camp unregister' to remove it from the registry entirely.

This group is 'camp lifecycle', not 'camp status' ('camp status' is the git
status wrapper).

```
camp lifecycle [flags]
```

### Examples

```
  camp lifecycle set old-project reference
  camp lifecycle list
```

### Options

```
  -h, --help   help for lifecycle
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp lifecycle list](../camp_lifecycle_list/)	 - List status counts across the registry
* [camp lifecycle set](../camp_lifecycle_set/)	 - Set a camp's lifecycle status
