---
title: "camp org create"
linkTitle: "camp org create"
description: "Create an org by joining campaigns (the current campaign if none named)"
---

## camp org create

Create an org by joining campaigns (the current campaign if none named)

### Synopsis

Create an org by joining campaigns to it.

Run inside a campaign with no campaign arguments to add the current campaign:
  camp org create obey

Or name the campaigns explicitly:
  camp org create obey obey-campaign obey-content

Orgs remain derived: "create" assigns membership and never makes an empty org.
Joining an org that already has members is allowed; there is no "already exists"
error, and a campaign already in the org is reported as unchanged.

```
camp org create <org> [campaign...] [flags]
```

### Examples

```
  camp org create obey
  camp org create client-acme acme-site other-site
```

### Options

```
  -h, --help   help for create
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group campaigns into orgs
