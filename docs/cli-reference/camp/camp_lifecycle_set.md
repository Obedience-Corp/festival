---
title: "camp lifecycle set"
linkTitle: "camp lifecycle set"
description: "Set a campaign's lifecycle status"
---

## camp lifecycle set

Set a campaign's lifecycle status

### Synopsis

Transition a campaign to one of: active, inactive, reference.

Any other value is rejected. Setting inactive or reference does not unregister
the campaign.

```
camp lifecycle set <campaign> <status> [flags]
```

### Examples

```
  camp lifecycle set old-project reference
```

### Options

```
  -h, --help   help for set
      --json   Output as JSON
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp lifecycle](../camp_lifecycle/)	 - Manage campaign lifecycle status
