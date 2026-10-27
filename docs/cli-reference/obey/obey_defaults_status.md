---
title: "obey defaults status"
linkTitle: "obey defaults status"
description: "Report the defaults this binary carries and whether a newer set exists"
---

## obey defaults status

Report the defaults this binary carries and whether a newer set exists

### Synopsis

Print each shipped defaults artifact with its version, content hash, and what
it decides.

This command REPORTS drift and never applies it. Taking a newer set is
"obey defaults adopt", which is not implemented in this release: adopting
requires a source of newer defaults, and where that source lives is a
distribution question this release does not answer.

```
obey defaults status [flags]
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

* [obey defaults](../obey_defaults/)	 - Inspect the shipped defaults this binary carries
