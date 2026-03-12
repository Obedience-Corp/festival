## fest types list

List available template types

### Synopsis

List all template types available at each festival level.

Types are discovered from:
  - Built-in templates (~/.config/fest/templates/)
  - Custom templates (.festival/templates/ in a festival)

Examples:
```bash
  fest types list                  # List all types grouped by level
  fest types list --level task     # List task-level types only
  fest types list --custom         # Show only custom types
  fest types list --all            # Include marker counts
  fest types list --json           # Machine-readable output
```

```
fest types list [flags]
```

### Options

```
  -a, --all            Show additional details including marker counts
  -c, --custom         Show only custom (user-defined) types
  -h, --help           help for list
      --json           Output as JSON
  -l, --level string   Filter by level (festival, phase, sequence, task)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest types](fest_types.md)	 - Discover and explore template types

