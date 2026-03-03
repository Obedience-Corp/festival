## fest commits

Query commits by festival element

### Synopsis

Query git commits that reference festival elements.

Search commits by task ID, sequence, or phase. Uses git log with grep
to find commits that contain festival references in their messages.

Examples:
```bash
  fest commits                           # All commits for current festival
  fest commits --task FEST-a3b2c1        # Commits for specific task
  fest commits --sequence 01_foundation  # Commits for sequence
  fest commits --phase 002_IMPLEMENT     # Commits for phase
  fest commits --limit 20                # Limit results
```

```
fest commits [flags]
```

### Options

```
  -h, --help              help for commits
      --json              output as JSON
      --limit int         maximum number of commits to return (default 50)
      --phase string      query commits for phase
      --sequence string   query commits for sequence
      --task string       query commits for specific task (e.g., FEST-a3b2c1)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

