---
title: "fest insert sequence"
linkTitle: "fest insert sequence"
description: "Insert a new sequence within a phase"
---

## fest insert sequence

Insert a new sequence within a phase

### Synopsis

Insert a new sequence after the specified number and renumber subsequent sequences.
		
The new sequence will be created with the proper 2-digit numbering format.

```
fest insert sequence [flags]
```

### Examples

```
  fest insert sequence --phase 001_PLAN --after 1 --name "validation"
  fest insert sequence --phase ./003_IMPLEMENT --after 0 --name "setup"
```

### Options

```
      --after int      insert after this sequence number (0 for beginning)
  -h, --help           help for sequence
      --name string    name of the new sequence
      --phase string   phase directory to insert sequence in
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

* [fest insert](../fest_insert/)	 - Insert new festival elements
