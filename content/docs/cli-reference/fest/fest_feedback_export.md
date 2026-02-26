## fest feedback export

Export collected feedback

### Synopsis

Export collected feedback to a file format.

Supports markdown, JSON, and YAML output formats.

Examples:
  fest feedback export --format markdown > report.md
  fest feedback export --format json > report.json
  fest feedback export --format yaml

```
fest feedback export [flags]
```

### Options

```
      --format string   output format: markdown, json, yaml (default "markdown")
  -h, --help            help for export
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest feedback](fest_feedback.md)	 - Manage structured feedback collection

