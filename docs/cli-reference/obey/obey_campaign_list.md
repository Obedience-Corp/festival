---
title: "obey campaign list"
linkTitle: "obey campaign list"
description: "List watched campaigns"
---

## obey campaign list

List watched campaigns

### Synopsis

Query the daemon for watched campaigns.

In a terminal, this opens a searchable browser (same quality bar as camp list).
Piped or non-interactive output prints a table that drops columns as the
terminal narrows. Use --tui to request the browser explicitly. If stdout is
not a TTY, the command still prints the table and reports that fallback.

```
obey campaign list [flags]
```

### Options

```
  -h, --help          help for list
      --org string    filter campaigns by org
      --tag strings   filter campaigns by tag (repeatable; all tags must match)
      --tui           browse campaigns interactively (default on a TTY; table if stdout is not a TTY)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey campaign](../obey_campaign/)	 - Manage campaigns
