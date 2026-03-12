## fest unlink

Remove festival-project link (context-aware)

### Synopsis

Remove the project link for the current location.

Context-aware behavior:
  - Inside a festival: unlinks that festival from its project
  - Inside a linked project: unlinks the project from its festival

This removes the association between the festival and its project directory.

```
fest unlink [flags]
```

### Examples

```
  fest unlink   # Remove link for current festival or project
```

### Options

```
  -h, --help   help for unlink
      --json   output in JSON format
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

