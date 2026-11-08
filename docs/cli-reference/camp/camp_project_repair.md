---
title: "camp project repair"
linkTitle: "camp project repair"
description: "Preview repair of a broken local project link"
---

## camp project repair

Preview repair of a broken local project link

### Synopsis

Inspect a broken projects/<name> link and possible local checkouts.

Discovery searches registered camps for checkouts with the same project name.
The preview shows each checkout's origin and existing .camp owner. A matching
folder name is only a discovery hint; select the intended checkout with --path.
Preview never changes the link, checkout, marker, or Git index. --apply
requires --path and replaces only a still-broken link; --undo restores the
saved old target. Repair changes a tracked symlink in the camp working tree
when that link is tracked. Neither action commits or changes checkout ownership.
Undo state is stored beside the local camp registry. The normal 'project link'
command creates a new shortcut and may attach the checkout; repair only
replaces an existing broken shortcut. See docs/guides/clone-sync-recovery.md.

Examples:
  camp project repair obey-voice
  camp project repair obey-voice --path ~/code/obey-voice
  camp project repair obey-voice --path ~/code/obey-voice --apply
  camp project repair obey-voice --undo
  camp project repair obey-voice --campaign obey-campaign --json

```
camp project repair <name> [flags]
```

### Options

```
      --apply             Apply the selected repair without committing
  -c, --campaign string   Target camp by registered name or ID
  -h, --help              help for repair
      --json              Output preview as JSON
      --path string       Inspect an explicit local checkout
      --undo              Restore the saved original link target
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp project](../camp_project/)	 - Manage camp projects
