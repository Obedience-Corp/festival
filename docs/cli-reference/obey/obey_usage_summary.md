---
title: "obey usage summary"
linkTitle: "obey usage summary"
description: "Show token and execution-time usage for one agent"
---

## obey usage summary

Show token and execution-time usage for one agent

### Synopsis

Display total tokens and execution time for a single agent across hourly and
daily windows.

This is agent-scoped: --agent is required. Pass --campaign to restrict the
totals to one campaign; omit it to aggregate the agent across all campaigns.
This command does not aggregate across agents.

```
obey usage summary [flags]
```

### Examples

```
  # Usage for an agent in the current-directory campaign
  obey usage summary --agent builder --campaign obey-platform

  # Usage for an agent across every campaign
  obey usage summary --agent builder
```

### Options

```
  -a, --agent string      agent name (required)
  -c, --campaign string   restrict to one campaign (name or UUID); omit to aggregate across all campaigns
  -h, --help              help for summary
      --json              output usage summary as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey usage](../obey_usage/)	 - View per-agent resource usage
