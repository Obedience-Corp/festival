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

```
festival install <festival|camp|fest> [flags]
```

### Options

```
      --allow-unverified   allow installing unsigned content without prompting
      --channel string     release channel (stable|rc|dev) (default "stable")
      --force              install a hub copy even when a package-manager suite is already on PATH
  -h, --help               help for install
      --json               emit JSON output
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
