---
title: "camp jobs retry"
linkTitle: "camp jobs retry"
description: "Requeue failed jobs"
---

## camp jobs retry

Requeue failed jobs

### Synopsis

Move failed jobs back to pending and start a worker for them.

Attempts reset, because a retry is you deciding the cause is gone. Keeping the
count would let a job that failed three times for a reason you have since fixed
be parked again on its first new attempt.

```
camp jobs retry <id|all> [flags]
```

### Options

```
  -h, --help   help for retry
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp jobs](../camp_jobs/)	 - Inspect and run camp's deferred commit queue
