---
title: "obey providers status"
linkTitle: "obey providers status"
description: "Show what local inference is holding on this node"
---

## obey providers status

Show what local inference is holding on this node

### Synopsis

Report this node's local inference state: which models are resident, at what
context tier, how long each has left on its idle timer, and how much of the
node's memory ceiling that adds up to.

The budget column always carries the source of its ceiling, one of measured,
runtime, override, or estimated, because a ceiling read from a platform API and
one computed from a percentage rule deserve different confidence.

Hardware detection, the budget arithmetic, and the runtime probe are read from
this host directly, because they are cheap loopback calls that stay useful while
the daemon is down. In-flight, queued, the warm-hit rate, and which residents
obey owns come from the daemon, because those describe a scheduler that runs
there. Where the daemon is not reachable, or is running no host resource
manager, those columns show a dash rather than a zero that would read as a
measurement.

This is read-only. It never warms a model, releases one, downloads one, or
writes configuration. A host with no local runtime is a normal host and reports
as such rather than failing.

```
obey providers status [flags]
```

### Options

```
  -h, --help   help for status
      --json   emit the report as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey providers](../obey_providers/)	 - List configured providers
