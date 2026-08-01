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

```
camp jobs drop <id|all> [flags]
```

### Options

```
  -h, --help   help for drop
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp jobs](../camp_jobs/)	 - Inspect and run camp's deferred commit queue
