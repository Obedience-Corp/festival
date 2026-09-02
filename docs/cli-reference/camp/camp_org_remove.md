---
title: "camp org remove"
linkTitle: "camp org remove"
description: "Return camps to the default org"
---

## camp org remove

Return camps to the default org

### Synopsis

Return one or more camps to the "default" org.

Since a camp is always in exactly one org, you do not name the org.
Removing a camp already in "default" is a no-op.

```
camp org remove <camp>... [flags]
```

### Examples

```
  camp org remove obey-content
  camp org remove acme-site other-site --json
```

### Options

```
  -h, --help   help for remove
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group camps into orgs
