## fest feedback add

Add a feedback observation

### Synopsis

Add a feedback observation for a defined criteria.

Use either flags or JSON input to add an observation.

Examples:
```bash
  fest feedback add --criteria "Code quality" --observation "Found duplicate logic"
  fest feedback add --json '{"criteria": "Performance", "observation": "N+1 query"}'
  fest feedback add --criteria "Code quality" --observation "..." --severity high --suggestion "Refactor"
```

```
fest feedback add [flags]
```

### Options

```
      --criteria string      criteria category
  -h, --help                 help for add
      --json string          JSON observation object
      --observation string   observation text
      --severity string      severity: low, medium, high
      --suggestion string    suggested action
      --task string          related task path
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

