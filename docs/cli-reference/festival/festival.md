---
title: "festival"
linkTitle: "festival"
description: "Festival hub: install, onboard, and launch camp/fest tools"
---

## festival

Festival hub: install, onboard, and launch camp/fest tools

### Synopsis

festival is the Festival hub: install and update camp/fest, browse plugins,
and open key camp/fest TUIs from one branded home.

Run with no arguments to open the interactive TUI. From the Launchpad, tools
run as real camp/fest processes; quit them to return here without relaunching
festival.

All your work, where you can find it.

Scripts and agents can use subcommands with --json for machine-readable output.

```
festival [flags]
```

### Options

```
  -h, --help   help for festival
      --tui    force the interactive TUI (requires a terminal)
```

### SEE ALSO

* [festival browse](../festival_browse/)	 - Browse available packages across registered marketplaces
* [festival completion](../festival_completion/)	 - Generate the autocompletion script for the specified shell
* [festival doctor](../festival_doctor/)	 - Diagnose installer state (PATH, sources, receipts)
* [festival install](../festival_install/)	 - Install the festival suite (camp, fest, and festival)
* [festival list](../festival_list/)	 - List installed packages
* [festival marketplace](../festival_marketplace/)	 - Manage marketplaces
* [festival shell-init](../festival_shell-init/)	 - Print shell code to put the installer-managed bin dir on PATH
* [festival uninstall](../festival_uninstall/)	 - Remove the installer-managed festival suite (receipt-owned files only)
* [festival update](../festival_update/)	 - Update the installed festival suite to the channel-latest release
* [festival version](../festival_version/)	 - Print the festival manager version
* [festival which](../festival_which/)	 - Resolve the real binary path for a suite tool
