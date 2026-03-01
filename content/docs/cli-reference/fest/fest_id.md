## fest id

Show the festival ID for the current context

### Synopsis

Display the festival ID for the current location.

Works from inside a festival directory or from a project linked to one.
The ID is read from fest.yaml metadata, falling back to the directory name.

Examples:
  fest id          # Print the festival ID (e.g., SR0001)
  fest id --json   # Output as JSON with id, name, and path

```
fest id [flags]
```

### Options

```
  -h, --help   help for id
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

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

