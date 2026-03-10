## fest system sync

System: Download latest fest templates from GitHub

### Synopsis

Download the latest fest methodology templates from GitHub to ~/.obey/fest/

This is a SYSTEM command that maintains fest itself, not your festival content.
It fetches the complete .festival/ template structure from the configured
repository and stores it locally for use with 'fest init' and 'fest system update'.

Run this periodically to get the latest methodology templates and documentation.

```
fest system sync [flags]
```

### Examples

```
  fest system sync                              # Use defaults (channel-based)
  fest system sync --channel stable               # Sync latest stable tag
  fest system sync --tag v0.1.0                   # Sync exact tag
  fest system sync --branch main                  # Sync from branch
  fest system sync --source github.com/user/repo  # Sync from specific repo
  fest system sync --force                        # Overwrite existing cache
```

### Options

```
      --branch string    Git branch to sync from (default: from config or 'main')
      --channel string   Release channel: stable or dev
      --dry-run          show what would be downloaded
      --force            overwrite existing files without checking
  -h, --help             help for sync
      --retry int        number of retry attempts (default 3)
      --source string    GitHub repository URL
      --tag string       Exact git tag to sync from (e.g., v0.1.0)
      --timeout int      timeout in seconds (default 30)
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

