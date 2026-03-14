---
title: "fest understand plugins"
linkTitle: "fest understand plugins"
description: "Show discovered plugins"
---

## fest understand plugins

Show discovered plugins

### Synopsis

Show all plugins discovered from various sources.

Plugins extend fest with additional commands. They are discovered from:
  1. User config repo manifest (~/.config/fest/active/user/plugins/manifest.yml)
  2. User config repo bin directory (~/.config/fest/active/user/plugins/bin/)
  3. System PATH (executables named fest-*)

Plugin executables follow the naming convention:
  fest-<group>-<name>  →  "fest <group> <name>"
  fest-export-jira     →  "fest export jira"

```
fest understand plugins [flags]
```

### Options

```
  -h, --help   help for plugins
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest understand](../fest_understand/)	 - Learn methodology FIRST - run before executing festival tasks
