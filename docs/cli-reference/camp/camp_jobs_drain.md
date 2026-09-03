---
title: "camp jobs drain"
linkTitle: "camp jobs drain"
description: "Wait until every lane is empty"
---

## camp jobs drain

Wait until every lane is empty

### Synopsis

Block until no queued commit is outstanding anywhere in the camp.

Commands that touch git history already do this for the repo they act on, so
this is for the cases that are not one command: before archiving a machine,
before a manual git operation camp does not wrap, or to watch the queue finish.

Artifact manifest jobs are exempt here as everywhere: they carry the commit
they describe, so they are correct whenever they land.

```
camp jobs drain [flags]
```

### Options

```
  -h, --help   help for drain
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp jobs](../camp_jobs/)	 - Inspect and run camp's deferred commit queue
