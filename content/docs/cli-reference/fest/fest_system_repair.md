## fest system repair

Fix festival directory layout issues

### Synopsis

Repair the festivals/ directory by detecting and fixing common issues.

This command analyzes your festival directory structure and fixes:
  - Renames planned/ → planning/ (old naming convention)
  - Moves completed/ → dungeon/completed/ (old layout)
  - Creates missing directories (ready/, ritual/, dungeon/ subdirs)
  - Creates .workflow.yaml if missing
  - Moves orphan festivals from dungeon/ root → dungeon/archived/
  - Converts legacy progress.yaml → progress_events.jsonl

The repair command is safe to run multiple times - it only makes changes
when issues are detected.

```
fest system repair [flags]
```

### Options

```
      --dry-run   preview changes without executing
      --force     skip confirmation prompt
  -h, --help      help for repair
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest system](fest_system.md)	 - Manage fest tool configuration and templates

