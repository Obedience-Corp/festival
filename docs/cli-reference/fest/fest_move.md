---
title: "fest move"
linkTitle: "fest move"
description: "Move files between festival and linked project"
---

## fest move

Move files between festival and linked project

### Synopsis

Move or copy files between a festival and its linked project directory.

The command automatically detects which direction to move based on your
current directory:

  - In festival directory: moves TO linked project
  - In linked project: moves TO festival

Examples:
```bash
  # In project directory, move file to festival
  fest move ./analysis.md

  # In festival directory, move file to project
  fest move ./specs/api.go --to-project

  # Copy instead of move (keeps original)
  fest move --copy ./notes.md

  # Force overwrite existing files
  fest move --force ./config.yml
```

Requirements:
  - Festival must have project_path set in fest.yaml
  - Must be in either festival or linked project directory

```
fest move <source> [destination] [flags]
```

### Options

```
  -c, --copy         copy instead of move
  -f, --force        overwrite existing files
  -h, --help         help for move
      --json         output in JSON format
      --to-project   move from festival to project
  -v, --verbose      show detailed output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest](../fest/)	 - Festival Methodology CLI - goal-oriented project management for AI agents
