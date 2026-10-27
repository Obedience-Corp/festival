---
title: "obey session abandoned"
linkTitle: "obey session abandoned"
description: "List bridged sessions that have gone quiet past the abandon horizon"
---

## obey session abandoned

List bridged sessions that have gone quiet past the abandon horizon

### Synopsis

List bridged sessions that have gone quiet past the abandon horizon.

A bridged session ends when its hook reports the end. That report never arrives
for a terminal someone simply closed, so those rows sit as RUNNING forever.
This lists the ones that look abandoned so an operator can decide.

It only ever lists. Nothing here ends a session.

What obey knows: when a session last did anything, and when its bridge last
reported in. What it cannot know: whether you left that session open on purpose
and mean to come back to it. That judgement is yours, which is why this is a
list and not a sweep.

```
obey session abandoned [flags]
```

### Options

```
      --campaign string    campaign ID (defaults to the current campaign)
  -h, --help               help for abandoned
      --horizon duration   how long a session must have been quiet to be listed (default 24h0m0s)
      --json               emit the full session records as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
