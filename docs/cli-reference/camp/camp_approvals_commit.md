---
title: "camp approvals commit"
linkTitle: "camp approvals commit"
description: "Commit approval events that are not committed yet"
---

## camp approvals commit

Commit approval events that are not committed yet

### Synopsis

Commit .campaign/approvals and nothing else.

Approval events are written uncommitted and picked up by the camp's next
ordinary commit or by listing approvals. This does only the commit, for a
script or before a push, so a request made on this machine is not left behind.

```
camp approvals commit [flags]
```

### Options

```
  -h, --help   help for commit
```

### Options inherited from parent commands

```
      --json       Emit a structured JSON result
      --no-color   disable colored output
```

### SEE ALSO

* [camp approvals](../camp_approvals/)	 - See what in this camp is waiting on your approval
