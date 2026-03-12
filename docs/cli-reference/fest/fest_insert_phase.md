## fest insert phase

Insert a new phase

### Synopsis

Insert a new phase after the specified number and renumber subsequent phases.
		
The new phase will be created with the proper 3-digit numbering format.

```
fest insert phase [festival-dir] [flags]
```

### Examples

```
  fest insert phase --after 1 --name "DESIGN_REVIEW"
  fest insert phase ./my-festival --after 2 --name "TESTING"
  fest insert phase --after 0 --name "REQUIREMENTS" # Insert at beginning
```

### Options

```
      --after int     insert after this phase number (0 for beginning)
  -h, --help          help for phase
      --name string   name of the new phase
```

### Options inherited from parent commands

```
      --backup          create backup before changes
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --no-color        disable colored output
      --verbose         show detailed output
```

### SEE ALSO

* [fest insert](fest_insert.md)	 - Insert new festival elements

