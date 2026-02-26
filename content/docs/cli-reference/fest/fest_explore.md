## fest explore

Interactive festival explorer with hierarchy drilldown

### Synopsis

Explore festivals interactively with vim-style navigation.

If inside a festival directory, shows that festival's phase/sequence/task hierarchy.
If in the festivals/ directory, shows a list of festivals for the detected status.
Otherwise, shows all active festivals by default.

STATUS can be: active, planning, completed, dungeon

```
fest explore [status] [flags]
```

### Examples

```
  fest explore              # Auto-detect context and explore
  fest explore active       # Explore active festivals
  fest explore planning     # Explore planning festivals
  fest explore completed    # Explore completed festivals
  fest explore dungeon      # Explore dungeon festivals
```

### Options

```
  -h, --help   help for explore
      --json   Output as JSON
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
* [fest explore active](fest_explore_active.md)	 - Explore active festivals
* [fest explore completed](fest_explore_completed.md)	 - Explore completed festivals
* [fest explore dungeon](fest_explore_dungeon.md)	 - Explore dungeon festivals
* [fest explore planning](fest_explore_planning.md)	 - Explore planning festivals

