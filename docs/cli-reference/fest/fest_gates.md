## fest gates

Manage quality gates - validation steps at sequence end

### Synopsis

Manage quality gate policies for festivals.

Quality gates are validation steps that run at the end of implementation sequences.
Gates are configured in fest.yaml under the implementation section.

Available Commands:
  show      Show effective gate policy from fest.yaml
  apply     Apply quality gates to sequences
  remove    Remove quality gate files from sequences

### Options

```
  -h, --help   help for gates
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
* [fest gates apply](fest_gates_apply.md)	 - Apply quality gates to sequences
* [fest gates remove](fest_gates_remove.md)	 - Remove quality gate files from sequences
* [fest gates show](fest_gates_show.md)	 - Show effective gate policy

