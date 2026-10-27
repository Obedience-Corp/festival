---
title: "obey session respin"
linkTitle: "obey session respin"
description: "Bring back the sessions that were live when the daemon last went down"
---

## obey session respin

Bring back the sessions that were live when the daemon last went down

### Synopsis

Recover the sessions a daemon restart killed.

Respin acts on sessions that were LIVE at the last shutdown, not on everything
that happens to be stopped. A session that failed for a real reason is not a
crash casualty and is left alone.

Each session is sorted into one of three groups:

  durable + resumable   resumed in place, or relaunched as a new linked row
  disposable            deliberately left dead -- reported, never hidden
  external              obey did not start it, so it cannot be resumed

Nothing here deletes anything. A session left dead keeps its row, its history,
and its transcript; only its process is gone.

Dry run is the default. Pass --yes to actually respin.

```
obey session respin [session-selector] [flags]
```

### Examples

```
  # See what would happen, across every campaign on this machine
  obey session respin --all-campaigns --dry-run

  # Do it
  obey session respin --all-campaigns --yes

  # Start a new obey-owned session in place of one obey never started
  obey session respin c81f0a22-4b1 --relaunch --yes
```

### Options

```
      --all-campaigns     sweep every campaign on this node
      --campaign string   campaign to sweep
      --dry-run           print the plan and change nothing (the default)
  -h, --help              help for respin
      --json              output the plan or result as JSON
      --relaunch          for an external session, start a new obey-owned session in the same working directory
      --yes               actually perform the respin
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
