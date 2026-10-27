---
title: "obey defaults adopt"
linkTitle: "obey defaults adopt"
description: "Take a newer defaults set (not implemented in this release)"
---

## obey defaults adopt

Take a newer defaults set (not implemented in this release)

### Synopsis

Adopt the newest published defaults set.

Not implemented in this release. Reporting drift is the useful half and is what
"obey defaults status" does today; adopting requires a source of published
defaults, which is a distribution question this release does not answer.

Running it prints that explanation with OBEY-1098 on the refusal line and exits
1, so a script that calls it fails rather than recording an adopt that never
happened.

When it lands, an override you set is KEPT across an adopt, and the output names
every field where your override now disagrees with the new default.

```
obey defaults adopt [flags]
```

### Options

```
  -h, --help   help for adopt
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey defaults](../obey_defaults/)	 - Inspect the shipped defaults this binary carries
