## fest renumber sequence

Renumber sequences within a phase

### Synopsis

Renumber all sequences in a phase starting from the specified number (default: 1).

Sequences are numbered with 2 digits (01, 02, 03, etc.).

If --phase is omitted and you're inside a phase directory, it will use the current phase.

```
fest renumber sequence [flags]
```

### Examples

```
  fest renumber sequence                            # Use current phase (if inside one)
  fest renumber sequence --phase 1                  # Numeric shortcut for phase 001_*
  fest renumber sequence --phase 001_PLAN           # Renumber sequences in phase
  fest renumber sequence --phase ./003_IMPLEMENT    # Use path to phase
  fest renumber sequence --phase 001_PLAN --start 2 # Start from 02
```

### Options

```
  -h, --help           help for sequence
      --phase string   phase directory (numeric shortcut, name, or path)
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

