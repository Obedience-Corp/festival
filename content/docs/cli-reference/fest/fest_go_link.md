## fest go link

Link current festival to a project directory (or vice versa)

### Synopsis

Create a bidirectional link between a festival and a project directory.

When run inside a festival:
  - Links the festival to the specified project directory
  - If no path provided, prompts for directory input

When run inside a project directory (non-festival):
  - Shows an interactive picker to select a festival to link
  - Links the current project to the selected festival

After linking:
  - 'fgo' in the festival jumps to the project
  - 'fgo' in the project jumps to the festival

Examples:
```bash
  # Inside a festival, link to project:
  fgo link /path/to/project
  fgo link .                    # Link to current directory (if not in festival)

  # Inside a project, show festival picker:
  fgo link
```

```
fest go link [path] [flags]
```

### Options

```
  -h, --help   help for link
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest go](fest_go.md)	 - Navigate to festivals/ - use 'fgo' after shell-init setup

