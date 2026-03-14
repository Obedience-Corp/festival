---
title: "fest system"
linkTitle: "fest system"
description: "Manage fest tool configuration and templates"
---

## fest system

Manage fest tool configuration and templates

### Synopsis

Commands for maintaining the fest tool itself.

These commands manage fest's templates, configuration, and methodology
files - NOT your festival content. Use these to keep fest up to date.

Available subcommands:
  config - Manage fest configuration settings (TUI)
  sync   - Download latest templates from GitHub
  update - Update .festival/ files from cached templates
  repair - Fix festival directory layout issues

### Options

```
  -h, --help   help for system
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest system config](../fest_system_config/)	 - Manage fest configuration settings
* [fest system repair](../fest_system_repair/)	 - Fix festival directory layout issues
* [fest system sync](../fest_system_sync/)	 - System: Download latest fest templates from GitHub
* [fest system update](../fest_system_update/)	 - System: Update fest methodology files from templates
