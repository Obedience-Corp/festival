---
title: "obey decision init"
linkTitle: "obey decision init"
description: "Write a starter decisions.yaml and show what the provider setup still needs"
---

## obey decision init

Write a starter decisions.yaml and show what the provider setup still needs

### Synopsis

Write a starter decisions.yaml with two example decisions, one yes_no and one
choice, next to daemon.yaml, or in <campaign>/.obey/ with --campaign. An
existing file is never overwritten; init says so and leaves it unchanged.

Then check the decision provider setup and print each missing piece with the
exact lines to add: a decision provider in daemon.yaml, enabled: true, or the
API key. init never edits daemon.yaml. When everything is in place it prints a
first command to try.

init makes no network call unless --check is passed. --check lists the
provider's models, the same live check obey providers runs.

```
obey decision init [flags]
```

### Options

```
      --campaign string   campaign root to write .obey/decisions.yaml in (default: next to daemon.yaml)
      --check             also run a live model listing against the provider
  -h, --help              help for init
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey decision](../obey_decision/)	 - Ask a decision provider typed questions about some state
