---
title: "festival which"
linkTitle: "festival which"
description: "Resolve the real binary path for a suite tool"
---

## festival which

Resolve the real binary path for a suite tool

### Synopsis

which resolves where a tool (camp, fest, obey, ...) actually runs from.

camp and fest install as shell functions for directory-changing navigation, so a
plain `which camp` prints the function. This resolves the binary on PATH (past the
function) and flags when a binary shadows the installer-managed one.

```
festival which <tool> [flags]
```

### Options

```
  -h, --help       help for which
      --json       emit JSON output
      --show-all   show the active and managed locations
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
