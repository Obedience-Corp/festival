---
title: "camp idea sync"
linkTitle: "camp idea sync"
description: "Reconcile intents against their tracked GitHub PRs"
---

## camp idea sync

Reconcile intents against their tracked GitHub PRs

### Synopsis

For every non-dungeon intent whose work_ref contains a GitHub PR URL,
query the PR's state via the gh CLI. Intents whose PR has merged are moved to
dungeon/done automatically, with a decision record and a ledger event. Intents
whose PR closed without merging are reported but never auto-moved -- resolve
those manually with 'camp intent move' or 'camp intent release'.

Requires the gh CLI (https://cli.github.com) on PATH with an authenticated
'gh auth login' session. Intents with no PR reference in work_ref are skipped
without needing gh at all.

Examples:
  camp intent sync              Reconcile and auto-close merged PRs
  camp intent sync --dry-run    Preview without moving anything

```
camp idea sync [flags]
```

### Options

```
      --dry-run     Preview without moving anything
  -h, --help        help for sync
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp idea](../camp_idea/)	 - Manage camp ideas
