---
title: "camp jobs"
linkTitle: "camp jobs"
description: "Inspect and run camp's deferred commit queue"
---

## camp jobs

Inspect and run camp's deferred commit queue

### Synopsis

Inspect and run the deferred commit queue.

Camp defers its own bookkeeping commits so they do not hold your terminal. The
queue lives under .campaign/cache/jobs and is machine-local and disposable:
git is the record, this is only the work still on its way there.

Run bare to see what is queued, running, or failed. Nothing here is required in
normal use: workers start themselves, and every command that touches git
history waits for the queue before it runs.

Examples:
  camp jobs                    # interactive browser in a TTY; table otherwise
  camp jobs --plain            # always print the table
  camp jobs --json             # the same, for scripts and agents
  camp jobs retry all          # requeue everything that failed
  camp jobs drop <id>          # give up on one job, keeping its content
  camp jobs drain              # wait for every lane, then exit

```
camp jobs [flags]
```

### Options

```
  -h, --help          help for jobs
  -i, --interactive   Open the interactive jobs browser (prints the table when stdout is not a terminal)
      --json          Emit a structured JSON result
      --plain         Print the table even when stdout is a terminal
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp jobs drain](../camp_jobs_drain/)	 - Wait until every lane is empty
* [camp jobs drop](../camp_jobs_drop/)	 - Give up on failed jobs, keeping their content
* [camp jobs retry](../camp_jobs_retry/)	 - Requeue failed jobs
* [camp jobs run](../camp_jobs_run/)	 - Serve every lane with pending work, then exit
