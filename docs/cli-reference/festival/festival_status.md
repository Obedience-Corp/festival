---
title: "festival status"
linkTitle: "festival status"
description: "Report where every suite tool resolves and what version it is"
---

## festival status

Report where every suite tool resolves and what version it is

### Synopsis

status reports, for camp, fest, festival, obey, and ob: the absolute path the
hub would run, the installer-managed path, the version the binary itself reports,
and the installed package's receipt version and channel. It also reports the
installer home, the managed bin dir, the configured marketplace, and whether the
prerequisites are present.

status reports; it does not grade. A missing tool is reported as absent, not as a
failure. Run `festival doctor` for a pass or fail verdict.

```
festival status [flags]
```

### Options

```
  -h, --help   help for status
      --json   emit JSON output
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
