---
title: "camp approvals withdraw"
linkTitle: "camp approvals withdraw"
description: "Clear a request whose source is no longer waiting"
---

## camp approvals withdraw

Clear a request whose source is no longer waiting

### Synopsis

Record that a request is no longer waiting, without approving or rejecting
anything.

Use it for a request that outlived its source: the workflow was deleted, the
worktree is gone, or the request was recorded by mistake. Withdrawing only
removes the request from this list. It does not unblock anything, because the
ledger never grants an approval: if the source is in fact still waiting, it
reports itself again the next time it is advanced.

--stale withdraws, without naming them, every request that can no longer be
decided: its source is on this machine and has finished, or is already past the
recorded step. Everything else is left alone. A source that is behind the
recorded step usually means this checkout has not caught up after a pull, and a
request whose source cannot be read here may be waiting on another machine; a
withdrawal is recorded in the shared ledger, so it would clear the request
there too.

Withdrawing clears that one request. Another request from the same source
stays pending.

Examples:
  camp approvals withdraw ap-1b9b5140 --reason "workflow deleted"
  camp approvals withdraw --stale

```
camp approvals withdraw [id] [flags]
```

### Options

```
  -h, --help            help for withdraw
      --reason string   Why the request is being withdrawn (required with an id)
      --stale           Withdraw every request whose source reports it is no longer waiting
```

### Options inherited from parent commands

```
      --json       Emit a structured JSON result
      --no-color   disable colored output
```

### SEE ALSO

* [camp approvals](../camp_approvals/)	 - See what in this camp is waiting on your approval
