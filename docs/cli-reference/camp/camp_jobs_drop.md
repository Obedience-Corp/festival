---
title: "camp jobs drop"
linkTitle: "camp jobs drop"
description: "Give up on failed jobs, keeping their content"
---

## camp jobs drop

Give up on failed jobs, keeping their content

### Synopsis

Discard failed jobs without discarding what they were going to commit.

Only the job file is removed. The intent, manifest, or marker the job was going
to commit stays in your working tree, uncommitted, for the next ordinary commit
to pick up. Dropping a job means "stop trying to commit this for me", never
"throw away my work".

Failed jobs only, unless you pass --running. A running job has a worker on it,
so giving up means stopping that worker: --running sends it SIGTERM, waits for
it to stop, and drops the job. Use it for a job 'camp jobs' reports as stalled,
where a commit message writer has stopped answering and nothing else will end
the wait.

Stopping a worker returns the other jobs it was running to pending, so they are
served again by the next worker. Only the jobs you named are dropped.

Examples:
  camp jobs drop <id>              # a failed job
  camp jobs drop all               # every failed job
  camp jobs drop --running <id>    # a stalled job, and the worker holding it

```
camp jobs drop <id|all> [flags]
```

### Options

```
  -h, --help      help for drop
      --running   Also drop running jobs, stopping the worker on each one's lane
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp jobs](../camp_jobs/)	 - Inspect and run camp's deferred commit queue
