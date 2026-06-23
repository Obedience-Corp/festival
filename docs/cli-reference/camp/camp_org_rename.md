---
title: "camp org rename"
linkTitle: "camp org rename"
description: "Rename an org, reassigning all members atomically"
---

## camp org rename

Rename an org, reassigning all members atomically

### Synopsis

Rename <old> to <new>, reassigning every member in one atomic write.

Errors if <old> has no members or if <new> already exists (no implicit merge).
Renaming the fallback org ("default" by default) makes <new> the new fallback.

```
camp org rename <old> <new> [flags]
```

### Examples

```
  camp org rename obey obedience
```

### Options

```
  -h, --help   help for rename
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group campaigns into orgs
