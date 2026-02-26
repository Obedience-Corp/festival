## fest go

Navigate to festivals/ - use 'fgo' after shell-init setup

### Synopsis

Navigate to your workspace's festivals directory.

The go command finds the festivals/ directory that has been registered
as your active workspace using 'fest init --register'.

By default, outputs 'cd /path' for human-friendly display.
Use --print to output just the bare path (for scripts, tools, and agents).

SHELL INTEGRATION (recommended):
  # Add to ~/.zshrc or ~/.bashrc:
  eval "$(fest shell-init zsh)"

Then use 'fgo' to navigate:
  fgo              Navigate to festivals root
  fgo 002          Navigate to phase 002
  fgo 2/1          Navigate to phase 2, sequence 1
  fgo fest_improv  Fuzzy match to fest-improvements-*

Without shell integration, use command substitution:
  cd "$(fest go --print)"
  cd "$(fest go 002 --print)"

Fuzzy matching is supported - partial names like "impl" will match
phases containing "IMPLEMENT". Multiple words narrow the search.

If no registered festivals are found, falls back to nearest festivals/.

```
fest go [target] [flags]
```

### Options

```
      --all         list all registered festivals directories
  -h, --help        help for go
      --json        output in JSON format
      --print       print path only (for shell integration, scripts, and agents)
      --workspace   show which workspace was detected
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents
* [fest go fest](fest_go_fest.md)	 - Navigate back to festival from linked project
* [fest go link](fest_go_link.md)	 - Link current festival to a project directory (or vice versa)
* [fest go list](fest_go_list.md)	 - List navigation shortcuts and links
* [fest go map](fest_go_map.md)	 - Create a navigation shortcut
* [fest go move](fest_go_move.md)	 - Move files between festival and linked project
* [fest go project](fest_go_project.md)	 - Navigate to linked project directory
* [fest go unmap](fest_go_unmap.md)	 - Remove a navigation shortcut

