## fest markers scaffold

Generate marker JSON from template

### Synopsis

Generate a JSON or YAML file with all template markers pre-populated as keys.

This allows agents to fill marker values without manually typing hint strings,
eliminating typos and reducing token usage.

Examples:
```
  # Generate from built-in template
  fest markers scaffold --template task-simple

  # Generate from existing file
  fest markers scaffold --file PHASE_GOAL.md

  # Output as YAML to a file
  fest markers scaffold --template sequence --format yaml --output markers.yaml

Available template aliases:
  task, task-simple, task-minimal    Task templates
  sequence, sequence-minimal         Sequence templates
  phase, phase-impl, phase-planning  Phase templates
  festival, festival-overview        Festival templates
  gate-testing, gate-review          Quality gate templates
```

```
fest markers scaffold [flags]
```

### Options

```
      --file string       Path to file with markers
      --format string     Output format: json or yaml (default "json")
  -h, --help              help for scaffold
      --output string     Output file path (default: stdout)
      --template string   Built-in template name (e.g., task, phase, sequence)
      --with-hints        Include hint descriptions as comments
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

