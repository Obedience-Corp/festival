---
title: "obey session set-disposition"
linkTitle: "obey session set-disposition"
description: "Change whether a session is brought back after a crash"
---

## obey session set-disposition

Change whether a session is brought back after a crash

### Synopsis

Set a session's disposition.

  durable      bring it back after a crash (the default)
  disposable   leave it dead, and say so

Disposition is deliberately mutable: a session's expected lifecycle is not
always known when it starts, and the operator who learns otherwise should be
able to say so without recreating the session.

This is not the same question as workload class. Workload class asks whether
someone is waiting on a turn; disposition asks whether the session should come
back. A single-shot review session is interactive and disposable at once.

Nothing is ever deleted either way. A disposable session keeps its row, its
history, and its transcript; only its process stays gone.

```
obey session set-disposition <session-selector> [flags]
```

### Examples

```
  # Stop offering this one for respin after a crash
  obey session set-disposition 7fcde681 --disposition disposable

  # Put it back
  obey session set-disposition 7fcde681 --disposition durable
```

### Options

```
  -c, --campaign string      campaign name or UUID
      --disposition string   durable or disposable
  -h, --help                 help for set-disposition
      --json                 output the result as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
