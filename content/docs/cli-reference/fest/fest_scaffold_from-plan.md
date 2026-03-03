## fest scaffold from-plan

Generate festival structure from a plan document

### Synopsis

Read a markdown plan document and generate the corresponding festival structure.

The plan document should follow the STRUCTURE.md format with a hierarchy section
containing phases, sequences, and tasks.

Examples:
```
  # Generate from a plan document
  fest scaffold from-plan --plan path/to/STRUCTURE.md --name my-festival

  # Preview what would be created
  fest scaffold from-plan --plan STRUCTURE.md --name my-fest --dry-run

  # Agent mode with JSON output
  fest scaffold from-plan --plan STRUCTURE.md --name my-fest --agent
```

```
fest scaffold from-plan [flags]
```

### Options

```
      --agent         Agent mode: JSON output
      --dest string   Destination: active or planning (default "active")
      --dry-run       Preview without creating files
  -h, --help          help for from-plan
      --json          Emit JSON output
      --name string   Festival name (required)
      --plan string   Path to the plan document (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest scaffold](fest_scaffold.md)	 - Generate festival structures from plans

