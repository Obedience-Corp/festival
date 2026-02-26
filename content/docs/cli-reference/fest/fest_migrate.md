## fest migrate

Migrate festival documents

### Synopsis

Migrate festival documents to add missing features or update formats.

Available migrations:
  frontmatter   Add YAML frontmatter to existing documents
  metadata      Add ID and metadata to existing festivals
  times         Populate time tracking data from file modification times

Examples:
  fest migrate frontmatter              # Add frontmatter to all docs
  fest migrate frontmatter --dry-run    # Preview changes
  fest migrate frontmatter --fix        # Auto-fix existing frontmatter
  fest migrate metadata                 # Add IDs to all festivals
  fest migrate metadata --dry-run       # Preview ID migrations
  fest migrate times                    # Populate time data from file stats
  fest migrate times --dry-run          # Preview time migrations

### Options

```
  -h, --help   help for migrate
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
* [fest migrate frontmatter](fest_migrate_frontmatter.md)	 - Add YAML frontmatter to existing documents
* [fest migrate metadata](fest_migrate_metadata.md)	 - Add metadata to existing festivals
* [fest migrate times](fest_migrate_times.md)	 - Populate time tracking data from file modification times

