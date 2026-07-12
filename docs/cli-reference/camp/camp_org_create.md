---
title: "camp org create"
linkTitle: "camp org create"
description: "Create an org (optionally empty) and join campaigns"
---

## camp org create

Create an org (optionally empty) and join campaigns

### Synopsis

Create a first-class org, optionally joining campaigns to it.

Run inside a campaign with no campaign arguments to add the current campaign:
  camp org create obey

Or name the campaigns explicitly:
  camp org create obey obey-campaign obey-content

Create an empty org with no members (works outside a campaign):
  camp org create obey --empty

Orgs are first-class: they persist in the registry even with zero members.
Joining an org that already has members is allowed; there is no "already exists"
error, and a campaign already in the org is reported as unchanged.

```
camp org create <org> [campaign...] [flags]
```

### Examples

```
  camp org create obey
  camp org create obey --empty
  camp org create client-acme acme-site other-site
```

### Options

```
      --empty   Create the org with no members (do not join any campaign)
  -h, --help    help for create
      --json    Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group campaigns into orgs
