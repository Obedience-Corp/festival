---
title: "fest markers"
linkTitle: "fest markers"
description: "Manage template markers in festival files"
---

## fest markers

Manage template markers in festival files

### Synopsis

View and manage unfilled template markers in festival files.

Template markers are placeholders that must be replaced with actual content:
  [FILL: description]    - Write actual content
  [REPLACE: guidance]    - Replace with your content
  [GUIDANCE: hint]       - Remove and write real content
  {{ placeholder }}      - Fill in the value

Use subcommands to list markers or fill them interactively.

### Options

```
  -h, --help          help for markers
      --json          Output results as JSON
      --path string   Festival path (default: current directory)
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
* [fest markers count](../fest_markers_count/)	 - Count unfilled template markers
* [fest markers list](../fest_markers_list/)	 - List all unfilled template markers
* [fest markers next](../fest_markers_next/)	 - Show the next file with unfilled markers
* [fest markers scaffold](../fest_markers_scaffold/)	 - Generate marker JSON from template
* [fest markers validate](../fest_markers_validate/)	 - Validate marker JSON against template
