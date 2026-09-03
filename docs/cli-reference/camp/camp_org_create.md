---
title: "camp org create"
linkTitle: "camp org create"
description: "Create an org (optionally empty) and join camps"
---

## camp org create

Create an org (optionally empty) and join camps

### Synopsis

Create a first-class org, optionally joining camps to it.

Run inside a camp with no camp arguments to add the current camp:
  camp org create obey

Or name the camps explicitly:
  camp org create obey obey-campaign obey-content

Create an empty org with no members (works outside a camp):
  camp org create obey --empty

Orgs are first-class: they persist in the registry even with zero members.
Joining an org that already has members is allowed; there is no "already exists"
error, and a camp already in the org is reported as unchanged.

```
camp org create <org> [camp...] [flags]
```

### Examples

```
  camp org create obey
  camp org create obey --empty
  camp org create client-acme acme-site other-site
```

### Options

```
      --empty   Create the org with no members (do not join any camp)
  -h, --help    help for create
      --json    Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group camps into orgs
