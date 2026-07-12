---
title: "camp festivals"
linkTitle: "camp festivals"
description: "List festivals across campaigns, filtered by org/tag"
---

## camp festivals

List festivals across campaigns, filtered by org/tag

### Synopsis

Aggregate festivals across campaigns, filtered by campaign org/tag.

Selects campaigns from the registry by --org and --tag (AND), then composes
'fest list --json' in each matching campaign and aggregates the result. The
campaign set defaults to active campaigns; --all-campaigns includes inactive and
reference campaigns. Festival-level flags (--status, --all, --since, --until,
--sort) are passed through to each underlying 'fest list'.

Runs one 'fest list' per matching campaign (sequentially); campaigns without a
festivals/ workspace contribute nothing. Read-only.

```
camp festivals [flags]
```

### Examples

```
  camp festivals --org obey
  camp festivals --org obey --status active
  camp festivals --tag paid-work --all-campaigns --json
```

### Options

```
      --all             Include completed/dungeon festivals, passed to fest list
      --all-campaigns   Include inactive/reference campaigns (default: active only)
  -h, --help            help for festivals
  -i, --interactive     Open the interactive festivals browser
      --json            Output as JSON
      --org string      Only campaigns in this org
      --since string    Festivals created on or after this date, passed to fest list
      --sort string     Festival sort, passed to fest list
      --status string   Festival status filter, passed to fest list
      --tag strings     Only campaigns carrying this tag (repeat for AND)
      --until string    Festivals created on or before this date, passed to fest list
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Campaign management CLI for multi-project AI workspaces
