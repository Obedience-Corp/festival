---
title: "festival doctor"
linkTitle: "festival doctor"
description: "Diagnose installer state (PATH, sources, receipts)"
---

## festival doctor

Diagnose installer state (PATH, sources, receipts). On a coherent package
install (AUR `festival-bin`, Homebrew, npm, or `obedience-festival`) doctor
exits 0 when camp/fest/festival are on PATH; `no marketplaces registered` is a
warn, not a failure. Doctor does not require `~/.obey/installer/bin` on PATH.

```
festival doctor [flags]
```

### Options

```
  -h, --help   help for doctor
      --json   emit JSON output
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
