## camp date

Append date suffix to file or directory name

### Synopsis

Append a date suffix to a file or directory name.

Renames a file or directory by appending a date to its name.
Shows a preview of the rename and asks for confirmation.

Date source (in priority order):
  --mtime    Use the file's last modified date
  --ago N    Use today minus N days
  (default)  Use today's date

Examples:
  camp date old-project              # old-project -> old-project-2026-01-27
  camp date ./docs/archive.md        # archive.md -> archive-2026-01-27.md
  camp date old-project --yes        # Skip confirmation
  camp date old-project --ago 3      # Use date from 3 days ago
  camp date old-project --mtime      # Use file's last modified date
  camp date old-project -f 20060102  # Use different date format

```
camp date <path> [flags]
```

### Options

```
  -a, --ago int         Use date from N days ago
      --dry-run         Show what would be done without making changes
  -f, --format string   Date format (Go time format) (default "2006-01-02")
  -h, --help            help for date
  -m, --mtime           Use file's last modified date
  -y, --yes             Skip confirmation prompt
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

