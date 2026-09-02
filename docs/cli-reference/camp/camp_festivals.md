---
title: "camp festivals"
linkTitle: "camp festivals"
description: "List festivals across camps, filtered by org/tag"
---

## camp festivals

List festivals across camps, filtered by org/tag

### Synopsis

Aggregate festivals across camps, filtered by camp org/tag.

Selects camps from the registry by --org and --tag (AND), then composes
'fest list --json' in each matching camp and aggregates the result. The
camp set defaults to active camps; --all-campaigns includes inactive and
reference camps. Festival-level flags (--status, --all, --since, --until,
--sort) are passed through to each underlying 'fest list'.

Runs one 'fest list' per matching camp (sequentially); camps without a
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
      --all-campaigns   Include inactive/reference camps (default: active only)
  -h, --help            help for festivals
  -i, --interactive     Open the interactive festivals browser
      --json            Output as JSON
      --org string      Only camps in this org
      --since string    Festivals created on or after this date, passed to fest list
      --sort string     Festival sort, passed to fest list
      --status string   Festival status filter, passed to fest list
      --tag strings     Only camps carrying this tag (repeat for AND)
      --until string    Festivals created on or before this date, passed to fest list
```

### Options inherited from parent commands

```
      --no-color   disable colored output
```

### SEE ALSO

* [camp](../camp/)	 - Manage your camps and the projects and festivals inside them
