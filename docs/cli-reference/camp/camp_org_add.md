---
title: "camp org add"
linkTitle: "camp org add"
description: "Assign campaigns to an org (reassigns; single-membership)"
---

## camp org add

Assign campaigns to an org (reassigns; single-membership)

### Synopsis

Assign one or more campaigns to <org>.

Membership is single, so this is also the reassign verb: a campaign added to a
new org leaves its previous org in the same step. The org is created implicitly.
Adding a campaign already in <org> is a no-op for that campaign.

```
camp org add <org> <campaign>... [flags]
```

### Examples

```
  camp org add obey obey-campaign obey-content
  camp org add client-acme acme-site --json
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

* [camp org](../camp_org/)	 - Group campaigns into orgs
