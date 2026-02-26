## camp leverage history

Show leverage score history over time

### Synopsis

Display leverage data aggregated over time from stored snapshots.

Shows how leverage has changed week by week. Use --by-author to see
per-contributor leverage breakdown based on git blame attribution.

Requires snapshot data from 'camp leverage backfill' or 'camp leverage snapshot'.

Examples:
  camp leverage history                            Show all history
  camp leverage history --project camp             Filter to one project
  camp leverage history --since 2025-06-01         Start from June 2025
  camp leverage history --json                     Output as JSON
  camp leverage history --by-author                Per-author breakdown

```
camp leverage history [flags]
```

### Options

```
      --by-author        show per-author leverage breakdown
  -h, --help             help for history
      --json             output as JSON
      --period string    aggregation period: weekly or monthly (default "monthly")
  -p, --project string   filter to specific project
      --since string     start date (YYYY-MM-DD)
      --until string     end date (YYYY-MM-DD, default: today)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp leverage](camp_leverage.md)	 - Compute leverage scores for campaign projects

