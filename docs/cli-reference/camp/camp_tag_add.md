---
title: "camp tag add"
linkTitle: "camp tag add"
description: "Add tags to a campaign"
---

## camp tag add

Add tags to a campaign

### Synopsis

Add one or more tags to a campaign (set semantics).

Re-adding a tag the campaign already carries is a no-op for that tag. Each tag
name must be lowercase letters, digits, and hyphens with no leading digit.

```
camp tag add <campaign> <tag>... [flags]
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

* [camp tag](../camp_tag/)	 - Label campaigns with tags
