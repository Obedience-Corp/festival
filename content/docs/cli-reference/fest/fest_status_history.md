## fest status history

View status change history

### Synopsis

View the history of status changes for the current entity.

History is stored in .fest/status_history.json within each festival.

```
fest status history [flags]
```

### Examples

```
  fest status history            # Show status history
  fest status history --limit 10 # Show last 10 changes
```

### Options

```
  -h, --help        help for history
      --json        output in JSON format
      --limit int   maximum number of entries to show (default 20)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest status](fest_status.md)	 - Manage and query festival entity statuses

