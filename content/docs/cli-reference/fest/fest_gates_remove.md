## fest gates remove

Remove quality gate files from sequences

### Synopsis

Remove quality gate task files from implementation sequences.

Only files with fest_managed: true marker in frontmatter are removed.
This safely removes only gate files, not regular task files.

By default, runs in dry-run mode showing what would be removed.
Use --approve to actually remove the files.

```
fest gates remove [flags]
```

### Examples

```
  # Preview what would be removed (dry-run is default)
  fest gates remove

  # Remove all gates from all sequences
  fest gates remove --approve

  # Remove gates from specific phase
  fest gates remove --phase 001_IMPLEMENTATION --approve

  # Remove gates from specific sequence
  fest gates remove --sequence 001_IMPL/01_core --approve

  # JSON output for automation
  fest gates remove --json
```

### Options

```
      --approve           Actually remove files
      --dry-run           Preview changes without removing (default) (default true)
  -h, --help              help for remove
      --json              Output JSON
      --phase string      Remove from specific phase
      --sequence string   Remove from specific sequence (format: phase/sequence)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest gates](fest_gates.md)	 - Manage quality gates - validation steps at sequence end

