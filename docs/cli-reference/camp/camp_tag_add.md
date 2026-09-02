---
title: "camp tag add"
linkTitle: "camp tag add"
description: "Add tags to a camp"
---

## camp tag add

Add tags to a camp

### Synopsis

Add one or more tags to a camp (set semantics).

Re-adding a tag the camp already carries is a no-op for that tag. Each tag
name must be lowercase letters, digits, and hyphens with no leading digit.

```
camp tag add <camp> <tag>... [flags]
```

### Examples

```
  camp tag add obey-campaign paid-work q3-2026
```

### Options

```
  -h, --help   help for add
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp tag](../camp_tag/)	 - Label camps with tags
