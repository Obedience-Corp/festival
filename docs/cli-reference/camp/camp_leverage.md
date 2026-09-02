---
title: "camp leverage"
linkTitle: "camp leverage"
description: "Compute leverage scores for the camp's projects"
---

## camp leverage

Compute leverage scores for the camp's projects

### Synopsis

Compute productivity leverage scores by comparing scc COCOMO estimates
against actual development effort.

Leverage score measures how much more output you produce versus what
traditional estimation models predict for the same team and time.

  FullLeverage   = (EstimatedPeople x EstimatedMonths) / (ActualPeople x ElapsedMonths)
  SimpleLeverage = EstimatedPeople / ActualPeople

Leverage commands commit the data they write under .campaign/leverage so the
score history stays versioned without extra steps. Nothing outside that
directory is staged. Pass --no-commit to skip it once, or run
'camp leverage config --autocommit=false' to turn it off for the camp.

Examples:
  camp leverage                              Show team leverage (auto-detect authors from git)
  camp leverage --author lance@example.com   Show personal leverage
  camp leverage --project camp               Show score for specific project
  camp leverage --json                       Output as JSON
  camp leverage --people 2                   Override team size
  camp leverage --verbose                    Show diagnostic details
  camp leverage .                            Score current directory only
  camp leverage --dir /path/to/repo          Score a specific directory

```
camp leverage [directory] [flags]
```

### Options

```
      --author string    filter by author email (git substring match: 'alice@co' matches 'alice@co.com')
      --by-author        show per-author leverage breakdown
      --dir string       score a specific directory (skips camp project resolution)
  -h, --help             help for leverage
      --json             output as JSON
      --no-commit        skip the automatic commit of .campaign/leverage data
      --no-legend        hide the leverage formula legend
      --people int       override team size (0 = auto-detect from git)
  -p, --project string   filter by project name
  -v, --verbose          show diagnostic details (config, project resolution, exclusions)
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
* [camp leverage backfill](../camp_leverage_backfill/)	 - Reconstruct historical leverage data from git history
* [camp leverage config](../camp_leverage_config/)	 - View or update leverage configuration
* [camp leverage history](../camp_leverage_history/)	 - Show leverage score history over time
* [camp leverage reset](../camp_leverage_reset/)	 - Clear all cached leverage data to allow full recomputation
* [camp leverage snapshot](../camp_leverage_snapshot/)	 - Capture current leverage state as a snapshot
