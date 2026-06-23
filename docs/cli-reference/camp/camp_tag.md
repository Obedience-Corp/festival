---
title: "camp tag"
linkTitle: "camp tag"
description: "Label campaigns with tags"
---

## camp tag

Label campaigns with tags

### Synopsis

Label campaigns with tags from a single global pool.

Tags are orthogonal to orgs: any campaign can carry any tag regardless of its
org, and the same tag can appear across orgs. Tags are a set per campaign
(re-adding is a no-op).

Commands:
  add   Add tags to a campaign
  rm    Remove tags from a campaign
  list  List all tags in use with counts

```
camp tag [flags]
```

### Examples

```
  camp tag add obey-campaign paid-work q3-2026
  camp tag rm obey-campaign q3-2026
  camp tag list
```

### Options

```
  -h, --help   help for tag
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp tag add](../camp_tag_add/)	 - Add tags to a campaign
* [camp tag list](../camp_tag_list/)	 - List all tags in use with campaign counts
* [camp tag rm](../camp_tag_rm/)	 - Remove tags from a campaign
