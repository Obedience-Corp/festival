---
title: "fest link"
linkTitle: "fest link"
description: "Link festival to project directory (context-aware)"
---

## fest link

Link festival to project directory (context-aware)

### Synopsis

Link a festival to a project directory with context-aware behavior.

When run inside a festival:
  - Links the festival to the specified project path
  - If no path provided, prompts for directory input

When run inside a project directory (non-festival):
  - Shows an interactive picker to select a festival to link
  - Links the current project to the selected festival

After linking, use 'fgo' to navigate between them.

The link is stored centrally in ~/.config/fest/navigation.yaml.
Use 'fest links' to see all festival-project links.
Use 'fest unlink' to remove the link for current festival.

```
fest link [path] [flags]
```

### Examples

```
  fest link /path/to/project   # Inside festival: link to project
  fest link .                  # Inside festival: link to cwd
  fest link                    # Inside festival: prompt for path
  fest link                    # Inside project: show festival picker
  fest link --show             # Display current link
```

### Options

```
  -h, --help   help for link
      --json   output in JSON format
      --show   show current link
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
