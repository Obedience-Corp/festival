---
title: "festival update"
linkTitle: "festival update"
description: "Update an installed package, or all managed packages with --all"
---

## festival update

Update an installed package, or all managed packages with --all

### Synopsis

update brings the installed festival suite (camp + fest) to the channel-latest release.

The target argument is optional and defaults to "festival", which updates the whole
suite. camp and fest are accepted as aliases: they are not published independently, so
passing either one still updates the whole suite and prints a notice saying so.

A package-manager install (AUR, Homebrew, npm) is never replaced with ~/.obey/installer.
When a newer suite exists and stdout is a TTY, update runs the package-manager command
(for example `yay -Syu festival-bin`) so camp, fest, and this hub upgrade together.
--json and non-TTY invocations print the command instead of running it.

--no-restart applies to obey only. An obey restart marks every live session failed, so a
caller with running sessions installs the new binaries and defers the restart; the result
reports service.deferred and names the restart command. A daemon that was not running is
started on the new version instead of restarted, and nothing is deferred. The flag is
accepted and ignored for festival, camp, and fest.

```
festival update [festival|camp|fest|obey|namespace/camp-plugin|namespace/fest-plugin] [flags]
```

### Options

```
      --all                update all eligible installed packages, retaining channels and deferring Obey restarts
      --allow-unverified   allow updating from unsigned content without prompting
      --channel string     override the release channel (default: the installed channel)
      --force              update/install a hub copy even when a package-manager suite is already on PATH
  -h, --help               help for update
      --json               emit JSON output
      --no-restart         install the new obey binaries without restarting the running daemon
```

### Options inherited from parent commands

```
      --managed   use a separate Festival-managed toolchain without modifying package-owned files
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
