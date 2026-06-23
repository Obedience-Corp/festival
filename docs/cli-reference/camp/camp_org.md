---
title: "camp org"
linkTitle: "camp org"
description: "Group campaigns into orgs"
---

## camp org

Group campaigns into orgs

### Synopsis

Group related campaigns into orgs.

Every campaign belongs to exactly one org (default "default"). Orgs are derived:
an org exists because a campaign names it, and disappears when its last member
leaves. There is no "org create".

Commands:
  add     Assign campaigns to an org (also reassigns; single-membership)
  remove  Return campaigns to the default org

```
camp org [flags]
```

### Examples

```
  camp org                                       Print the current campaign's org
  camp org add obey obey-campaign obey-content   Move campaigns into "obey"
  camp org remove obey-content                   Return a campaign to "default"
```

### Options

```
  -h, --help   help for org
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
* [camp org add](../camp_org_add/)	 - Assign campaigns to an org (reassigns; single-membership)
* [camp org list](../camp_org_list/)	 - List orgs with member and active counts
* [camp org remove](../camp_org_remove/)	 - Return campaigns to the default org
* [camp org rename](../camp_org_rename/)	 - Rename an org, reassigning all members atomically
* [camp org show](../camp_org_show/)	 - Show an org's member campaigns
