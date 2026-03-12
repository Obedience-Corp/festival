## fest remove task

Remove a task and renumber subsequent tasks

### Synopsis

Remove a task by number or name and automatically renumber all following tasks.

Warning: This will permanently delete the task file!

If --sequence is omitted and you're inside a sequence directory, it will use the current sequence.

```
fest remove task [task-number|task-name] [flags]
```

### Examples

```
  fest remove task 2                              # Use current sequence (if inside one)
  fest remove task --sequence 1 2                 # Numeric shortcut for sequence 01_*
  fest remove task --phase 1 --sequence 2 3       # Phase 001_*, sequence 02_*
  fest remove task --sequence ./path/to/seq 02_validate.md
```

### Options

```
  -h, --help              help for task
      --phase string      phase directory (numeric shortcut, name, or path)
      --sequence string   sequence directory (numeric shortcut, name, or path)
```

### Options inherited from parent commands

```
      --backup          create backup before removal
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --dry-run         preview changes without applying them (default true)
      --force           skip confirmation prompts
      --no-color        disable colored output
      --verbose         show detailed output
```

### SEE ALSO

* [fest remove](fest_remove.md)	 - Remove festival elements and renumber

