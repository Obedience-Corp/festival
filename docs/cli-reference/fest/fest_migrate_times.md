---
title: "fest migrate times"
linkTitle: "fest migrate times"
description: "Populate time tracking data from file modification times"
---

## fest migrate times

Populate time tracking data from file modification times

### Synopsis

Retroactively populate time tracking data for existing festivals.

This command walks through festivals and uses file modification times to
infer task completion times for tasks that don't have explicit time data.

The migration:
- Finds all festivals in the specified path (or current directory)
- For each completed task without time data, infers time from file stats
- Updates progress.yaml with the inferred times
- Calculates total work time for the festival

Use --dry-run to preview changes without modifying files.

```
fest migrate times [path] [flags]
```

### Examples

```
  fest migrate times                    # Migrate current festival
  fest migrate times festivals/         # Migrate all festivals in directory
  fest migrate times --dry-run          # Preview changes
  fest migrate times --verbose          # Show detailed progress
```

### Options

```
      --dry-run   preview changes without modifying files
  -h, --help      help for times
      --verbose   show detailed progress
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
```

### SEE ALSO

* [fest migrate](../fest_migrate/)	 - Migrate festival documents
