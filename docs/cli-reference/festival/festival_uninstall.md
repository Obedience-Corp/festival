---
title: "festival uninstall"
linkTitle: "festival uninstall"
description: "Remove an installer-managed package (receipt-owned files only)"
---

## festival uninstall

Remove an installer-managed package (receipt-owned files only)

### Synopsis

uninstall removes receipt-owned files only. app removes Festival App the way it was installed: the app bundle on macOS, the App's own uninstaller on Windows, apt-get remove for the deb, and the AppImage with its menu entry and icon on Linux. It refuses while Festival App is running.

```
festival uninstall <festival|camp|fest|obey|app|namespace/camp-plugin|namespace/fest-plugin> [flags]
```

### Options

```
  -h, --help   help for uninstall
      --json   emit JSON output
```

### Options inherited from parent commands

```
      --managed   use a separate Festival-managed toolchain without modifying package-owned files
```

### SEE ALSO

* [festival](../festival/)	 - Festival hub: install, onboard, and launch camp/fest tools
