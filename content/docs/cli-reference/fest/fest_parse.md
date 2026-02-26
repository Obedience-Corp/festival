## fest parse

Parse festival documents into structured output

### Synopsis

Parse festival documents into structured JSON or YAML output.

This command walks the festival hierarchy and produces structured output
suitable for external tool integration (e.g., Guild v3, visualization tools).

Examples:
  fest parse                         # Parse current festival as JSON
  fest parse --format yaml           # Output as YAML
  fest parse --type task             # Output flat list of tasks
  fest parse --type gate             # Output only gates
  fest parse --all                   # Parse all festivals
  fest parse --compact               # Summary only (no children)
  fest parse --full                  # Include document content
  fest parse -o output.json          # Write to file

```
fest parse [path] [flags]
```

### Options

```
      --all             parse all festivals in workspace
      --compact         compact output (summary only)
      --format string   output format (json, yaml) (default "json")
      --full            include document content
  -h, --help            help for parse
      --infer           infer frontmatter when missing (default true)
  -o, --output string   write output to file
      --type string     filter by entity type (task, gate, phase, sequence)
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

