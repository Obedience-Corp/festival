## camp leverage backfill

Reconstruct historical leverage data from git history

### Synopsis

Backfill analyzes past commits to build leverage-over-time data.

Uses git worktrees to check out weekly snapshots, run scc analysis,
and compute leverage scores at each point in time. Results are stored
as snapshots for later retrieval via 'camp leverage history'.

Backfill is incremental: re-running only processes dates without
existing snapshots.

Examples:
  camp leverage backfill                       Backfill all projects
  camp leverage backfill --project camp        Backfill specific project
  camp leverage backfill --workers 2           Limit concurrency
  camp leverage backfill --since 2025-06-01    Backfill from June 2025

```
camp leverage backfill [flags]
```

### Options

```
  -h, --help             help for backfill
  -p, --project string   backfill a single project
      --since string     start date (YYYY-MM-DD), overrides config project_start
  -w, --workers int      number of parallel workers (default 4)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp leverage](camp_leverage.md)	 - Compute leverage scores for campaign projects

