## fest understand extensions

Show loaded extensions

### Synopsis

Show all methodology extensions loaded from various sources.

Extensions are workflow pattern packs containing templates, agents, and rules.
They are loaded from three sources with the following precedence:

  1. Project-local: .festival/extensions/ (highest priority)
  2. User config: ~/.config/fest/active/festivals/.festival/extensions/
  3. Built-in: ~/.config/fest/festivals/.festival/extensions/ (lowest priority)

Higher priority sources override lower ones when extensions have the same name.

```
fest understand extensions [flags]
```

### Options

```
  -h, --help   help for extensions
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest understand](fest_understand.md)	 - Learn methodology FIRST - run before executing festival tasks

