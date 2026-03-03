## fest feedback init

Initialize feedback collection

### Synopsis

Initialize feedback collection with defined criteria.

Creates a feedback/ directory in the current festival with
configuration for the specified criteria.

Examples:
```bash
  fest feedback init --criteria "Code quality observations"
  fest feedback init --criteria "Performance concerns" --criteria "Methodology suggestions"
```

```
fest feedback init [flags]
```

### Options

```
      --criteria strings   feedback criteria (required)
  -h, --help               help for init
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

