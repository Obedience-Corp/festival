## fest scaffold

Generate festival structures from plans

### Synopsis

Generate complete festival structures from plan documents.

The scaffold command reads a markdown plan document (like STRUCTURE.md) and
generates the corresponding festival directory structure with phases, sequences,
and tasks pre-populated from the plan.

Examples:
  fest scaffold from-plan --plan path/to/STRUCTURE.md --name my-festival
  fest scaffold from-plan --plan STRUCTURE.md --dry-run
  fest scaffold from-plan --plan STRUCTURE.md --name my-fest --json

### Options

```
  -h, --help   help for scaffold
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
* [fest scaffold from-plan](fest_scaffold_from-plan.md)	 - Generate festival structure from a plan document

