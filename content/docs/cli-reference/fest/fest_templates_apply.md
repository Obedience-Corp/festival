## fest templates apply

Apply a template with variables

### Synopsis

Apply a template, substituting {{variables}} with provided values.

Variables can be provided as:
  - JSON string: --vars '{"name": "value"}'
  - File reference: --vars @variables.json

Examples:
```bash
  fest templates apply component_test --vars '{"name": "UserService"}'
  fest templates apply api_endpoint -o ./api.md --vars @vars.json
```

```
fest templates apply <name> [flags]
```

### Options

```
  -h, --help            help for apply
  -o, --output string   output file path (default: stdout)
      --preview         show result without writing
      --vars string     JSON object or @file with variable values (default "{}")
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest templates](fest_templates.md)	 - Manage agent-created templates within a festival

