---
title: "festival shell-init"
linkTitle: "festival shell-init"
description: "Print shell code to put the installer-managed bin dir on PATH"
---

## festival shell-init

Print shell code to put the installer-managed bin dir on PATH

```
festival shell-init <zsh|bash|fish|powershell> [flags]
```

### Options

```
      --append   offer to persist the managed bin on PATH after showing the change
      --check    report whether the managed bin dir is on PATH
  -h, --help     help for shell-init
      --yes      apply without asking (requires --append)
```

### Options inherited from parent commands

```
      --managed   use a separate Festival-managed toolchain without modifying package-owned files
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
