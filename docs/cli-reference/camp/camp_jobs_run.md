---
title: "camp jobs run"
linkTitle: "camp jobs run"
description: "Serve every lane with pending work, then exit"
---

## camp jobs run

Serve every lane with pending work, then exit

### Synopsis

Serve every lane with pending work and exit when none is left.

This is both the entrypoint camp spawns detached after enqueuing work, and the
way to run the queue in the foreground when something looks wrong. Running it
by hand is safe at any time: lanes are locked per repo, so a second worker
finds the lanes taken and exits rather than duplicating anything.

It prints nothing on success. Per-job transitions go to
.campaign/cache/jobs/worker.log, which is where a detached worker's story is;
'camp jobs' is the surface for looking at what is still outstanding.

```
camp jobs run [flags]
```

### Options

```
      --campaign string   Campaign root to serve (defaults to the detected campaign)
  -h, --help              help for run
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp jobs](../camp_jobs/)	 - Inspect and run camp's deferred commit queue
