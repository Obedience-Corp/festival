## fest ritual run

Create a new run of a ritual festival in active/

### Synopsis

Copy a ritual festival from ritual/ to active/ with a hex run counter.

The ritual template stays in ritual/ untouched. A new copy is placed
in active/ with an appended hex counter (e.g., -0001, -000A, -00FF).

The counter auto-increments by scanning active/ and dungeon/completed/
for existing runs.

```
fest ritual run <ritual-name-or-id> [flags]
```

### Options

```
  -h, --help   help for run
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

* [fest ritual](fest_ritual.md)	 - Manage repeatable ritual festivals

