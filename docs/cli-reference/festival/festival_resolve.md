---
title: "festival resolve"
linkTitle: "festival resolve"
description: "Print the absolute path the hub would run a tool from"
---

## festival resolve

Print the absolute path the hub would run a tool from

### Synopsis

resolve prints the absolute path festival itself would run <tool> from: the
installer-managed bin dir first, except when a package manager owns the suite,
where PATH wins so the hub runs the binary the shell runs. In both cases the
other location is the fallback.

This differs from `festival which`, which reports whatever PATH finds first and
flags shadowing. Use resolve when a program is about to run the binary and which
when a person is asking what is shadowing what.

```
festival resolve <tool> [flags]
```

### Options

```
  -h, --help   help for resolve
      --json   emit JSON output
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
