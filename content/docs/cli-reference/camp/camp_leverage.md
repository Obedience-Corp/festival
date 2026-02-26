## camp leverage

Compute leverage scores for campaign projects

### Synopsis

Compute productivity leverage scores by comparing scc COCOMO estimates
against actual development effort.

Leverage score measures how much more output you produce versus what
traditional estimation models predict for the same team and time.

  FullLeverage   = (EstimatedPeople x EstimatedMonths) / (ActualPeople x ElapsedMonths)
  SimpleLeverage = EstimatedPeople / ActualPeople

Examples:
  camp leverage                              Show team leverage (auto-detect authors from git)
  camp leverage --author lance@example.com   Show personal leverage
  camp leverage --project camp               Show score for specific project
  camp leverage --json                       Output as JSON
  camp leverage --people 2                   Override team size
  camp leverage --verbose                    Show diagnostic details

```
camp leverage [flags]
```

### Options

```
      --author string    filter by author email (git substring match — 'alice@co' matches 'alice@co.com')
      --by-author        show per-author leverage breakdown
  -h, --help             help for leverage
      --json             output as JSON
      --no-legend        hide the leverage formula legend
      --people int       override team size (0 = auto-detect from git)
  -p, --project string   filter by project name
  -v, --verbose          show diagnostic details (config, project resolution, exclusions)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces
* [camp leverage backfill](camp_leverage_backfill.md)	 - Reconstruct historical leverage data from git history
* [camp leverage config](camp_leverage_config.md)	 - View or update leverage configuration
* [camp leverage history](camp_leverage_history.md)	 - Show leverage score history over time
* [camp leverage reset](camp_leverage_reset.md)	 - Clear all cached leverage data to allow full recomputation
* [camp leverage snapshot](camp_leverage_snapshot.md)	 - Capture current leverage state as a snapshot

