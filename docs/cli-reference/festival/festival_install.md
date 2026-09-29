---
title: "festival install"
linkTitle: "festival install"
description: "Install the festival suite (camp, fest, and festival)"
---

## festival install

Install the festival suite (camp, fest, and festival)

### Synopsis

install installs the festival suite (camp, fest, and festival).

The target is required. festival, camp, and fest all install the suite bundle;
camp and fest are not published independently, so passing either one still installs
the whole suite and prints a notice saying so.

obey installs the obey daemon and the ob developer CLI as their own package.

--no-restart applies to obey only. Installing over a running daemon restarts it so the
supervised process is the version that was just placed, which marks every live session
failed; --no-restart installs the binaries, leaves the daemon alone, and reports the
restart as pending. The flag is accepted and ignored for festival, camp, and fest.

```
festival install <festival|camp|fest|obey> [flags]
```

### Options

```
      --allow-unverified   allow installing unsigned content without prompting
      --channel string     release channel (stable|rc|dev) (default "stable")
      --force              install a hub copy even when a package-manager suite is already on PATH
  -h, --help               help for install
      --json               emit JSON output
      --no-restart         install the new obey binaries without restarting the running daemon
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
