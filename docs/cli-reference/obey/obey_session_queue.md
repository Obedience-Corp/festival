---
title: "obey session queue"
linkTitle: "obey session queue"
description: "Sessions ordered by which ones need you, without a terminal"
---

## obey session queue

Sessions ordered by which ones need you, without a terminal

### Synopsis

Sessions ordered by which ones need you.

Same ordering obey top renders, most urgent first, but written to stdout rather
than drawn on a screen. It works over SSH, in a pipe, and in CI, none of which
obey top can do.

By default it shows only the sessions that want something. Pass --all to see
every session in queue order, including the ones that need nothing.

The reason on each row is the daemon's own attention state ; waiting on your
input, gone quiet mid-work, finished with results nobody has read, failed ; not
a guess made from the status column.

Nothing here changes a session. It is a list.

```
obey session queue [flags]
```

### Options

```
      --all               include sessions that need nothing
      --campaign string   campaign ID (defaults to the current campaign)
      --follow            keep re-rendering as the queue changes
  -h, --help              help for queue
      --json              emit the full session records as JSON, in queue order
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
