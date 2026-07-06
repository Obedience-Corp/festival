---
title: "fest plugins"
linkTitle: "fest plugins"
description: "List discovered fest plugins"
---

## fest plugins

List discovered fest plugins

### Synopsis

List fest plugins discovered from the active config repo manifest and PATH.

Any executable named fest-<name> on PATH is a fest plugin and runs as
"fest <name> [args...]". Plugins declared in the active user config repo
manifest (plugins/manifest.yml) carry richer metadata such as summaries.

```
fest plugins [flags]
```

### Examples

```
  fest plugins
  fest plugins --json
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

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
