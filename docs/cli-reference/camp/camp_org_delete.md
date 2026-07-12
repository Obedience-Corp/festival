---
title: "camp org delete"
linkTitle: "camp org delete"
description: "Delete an org (empty only unless --force)"
---

## camp org delete

Delete an org (empty only unless --force)

### Synopsis

Delete a first-class org from the registry.

Empty orgs delete without flags. Orgs with members require --force, which
reassigns every member to the fallback org and then deletes the org.

The fallback org cannot be deleted.

```
camp org delete <name> [flags]
```

### Examples

```
  camp org delete empty-org
  camp org delete obey --force
  camp org delete empty-org --json
```

### Options

```
      --force   Reassign members to the fallback org, then delete
  -h, --help    help for delete
      --json    Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp org](../camp_org/)	 - Group campaigns into orgs
