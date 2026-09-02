---
title: "camp notify dismiss"
linkTitle: "camp notify dismiss"
description: "Stop showing a notice"
---

## camp notify dismiss

Stop showing a notice

### Synopsis

Dismiss a notice by id.

Dismissal is per signature, not per kind. Dismissing the notice for one
artifact root does not silence a root you declare later: that one has its own
id and notifies on its own terms.

```
camp notify dismiss <notice-id> [flags]
```

### Options

```
  -h, --help   help for dismiss
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp notify](../camp_notify/)	 - Manage camp state notices
