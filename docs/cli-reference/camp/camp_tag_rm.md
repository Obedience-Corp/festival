---
title: "camp tag rm"
linkTitle: "camp tag rm"
description: "Remove tags from a camp"
---

## camp tag rm

Remove tags from a camp

### Synopsis

Remove one or more tags from a camp.

Removing a tag the camp does not carry is a no-op for that tag.

```
camp tag rm <camp> <tag>... [flags]
```

### Examples

```
  camp tag rm obey-campaign q3-2026
```

### Options

```
  -h, --help   help for rm
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp tag](../camp_tag/)	 - Label camps with tags
