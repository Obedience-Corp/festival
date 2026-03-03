## fest markers validate

Validate marker JSON against template

### Synopsis

Validate a marker JSON or YAML file against a template to detect issues.

This command checks for:
  - Missing required markers (present in template but not in file)
  - Empty marker values
  - Unknown markers (possible typos)

In strict mode (--strict), unknown markers cause validation to fail.

Examples:
```bash
  # Validate against built-in template
  fest markers validate --file markers.json --template task-simple

  # Validate against existing file
  fest markers validate --file markers.json --source PHASE_GOAL.md

  # Strict mode - fail on unknown markers
  fest markers validate --file markers.json --template task --strict
```

```
fest markers validate [flags]
```

### Options

```
      --file string       Marker file to validate (required)
  -h, --help              help for validate
      --source string     Source file to validate against
      --strict            Fail on unknown markers
      --template string   Template to validate against
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --json            Output results as JSON
      --no-color        disable colored output
      --path string     Festival path (default: current directory)
      --verbose         enable verbose output
```

### SEE ALSO

* [fest markers](fest_markers.md)	 - Manage template markers in festival files

