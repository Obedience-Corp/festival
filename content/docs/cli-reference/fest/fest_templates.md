## fest templates

Manage agent-created templates within a festival

### Synopsis

Create, apply, and manage templates for repetitive tasks.

Agent templates use simple {{variable}} syntax for substitution.
Templates are stored in .templates/ within the festival directory.

Examples:
  fest templates create component_test
  fest templates apply component_test --vars '{"name": "UserService"}'
  fest templates list

### Options

```
  -h, --help   help for templates
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
* [fest templates apply](fest_templates_apply.md)	 - Apply a template with variables
* [fest templates create](fest_templates_create.md)	 - Create a new template
* [fest templates list](fest_templates_list.md)	 - List available templates

