---
title: "festival shell-init"
linkTitle: "festival shell-init"
description: "Print shell code to put the installer-managed bin dir on PATH"
---

## festival shell-init

Print origin-aware shell code. Package installs print `source` of the packaged
helper (not `export PATH=` for `~/.obey/installer/bin`). Hub-managed installs
still prepend the managed bin dir.

```
festival shell-init <zsh|bash|fish> [flags]
```

### Options

```
      --check   report whether the managed bin dir is on PATH
  -h, --help    help for shell-init
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
