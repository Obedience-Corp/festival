## fest validate quality-gates

Validate quality gates exist

### Synopsis

Validate that implementation sequences have quality gate tasks.

Only implementation phases are checked. Other phase types are skipped.

Required implementation gates:
  • testing
  • review
  • iterate
  • commit

Use --fix to automatically add missing quality gates.
Sequences matching excluded patterns (*_planning, *_research, etc.) are skipped.

```
fest validate quality-gates [festival-path] [flags]
```

### Options

```
      --fix    Automatically add missing quality gates
  -h, --help   help for quality-gates
      --json   Output results as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest validate](fest_validate.md)	 - Check festival structure - find missing task files and issues

