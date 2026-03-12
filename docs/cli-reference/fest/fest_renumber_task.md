## fest renumber task

Renumber tasks within a sequence

### Synopsis

Renumber all tasks in a sequence starting from the specified number (default: 1).

Tasks are numbered with 2 digits (01, 02, 03, etc.).
Parallel tasks (multiple tasks with the same number) are preserved.

If --sequence is omitted and you're inside a sequence directory, it will use the current sequence.
Use --phase to specify the phase when using numeric sequence shortcuts.

```
fest renumber task [flags]
```

### Examples

```
  fest renumber task                              # Use current sequence (if inside one)
  fest renumber task --sequence 1                 # Numeric shortcut for sequence 01_*
  fest renumber task --phase 1 --sequence 2       # Phase 001_*, sequence 02_*
  fest renumber task --sequence 01_requirements   # Use sequence name
  fest renumber task --sequence ./path/to/seq     # Use path to sequence
```

### Options

```
  -h, --help              help for task
      --phase string      phase directory (numeric shortcut, name, or path)
      --sequence string   sequence directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before renumbering
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --skip-dry-run    skip preview and apply changes immediately
      --start int       starting number for renumbering (default 1)
      --verbose         show detailed output
```

### SEE ALSO

* [fest renumber](fest_renumber.md)	 - Renumber festival elements

