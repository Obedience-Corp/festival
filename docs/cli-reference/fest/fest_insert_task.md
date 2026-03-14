---
title: "fest insert task"
linkTitle: "fest insert task"
description: "Insert a new task within a sequence"
---

## fest insert task

Insert a new task within a sequence

### Synopsis

Insert a new task after the specified number and renumber subsequent tasks.
		
The new task will be created with the proper 2-digit numbering format.
Note: Tasks are markdown files, so .md extension will be added automatically.

```
fest insert task [flags]
```

### Examples

```
  fest insert task --sequence 001_PLAN/01_requirements --after 1 --name "validate_input"
  fest insert task --sequence ./path/to/sequence --after 0 --name "setup"
```

### Options

```
      --after int         insert after this task number (0 for beginning)
  -h, --help              help for task
      --name string       name of the new task (without .md extension)
      --sequence string   sequence directory to insert task in
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
