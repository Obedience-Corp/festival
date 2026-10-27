---
title: "obey session list"
linkTitle: "obey session list"
description: "List agent sessions"
---

## obey session list

List agent sessions

### Synopsis

List agent sessions managed by the daemon.

The campaign is resolved the same way as observe and the session detail
commands: pass --campaign explicitly, or run inside a campaign directory to use
the current campaign. By default this shows all active sessions in that
campaign. Use --all to include stopped and failed session history. Filter with
-p (provider), -s (status), or --auto-commit for sessions created by camp's
auto-write hook.

--auto-commit pre-fills the agent filter with ob-commit, so it cannot be
combined with a different --agent or with --selector (which also sets agent/id
filters). Use --agent ob-commit explicitly if you need to pair it with other
agent-compatible flags.

```
obey session list [flags]
```

### Examples

```
  # Sessions in the current-directory campaign
  obey session list

  # Include stopped and failed history
  obey session list --all

  # Sessions in a named campaign, as JSON
  obey session list --campaign obey-platform --json

  # Running sessions for one agent
  obey session list --campaign obey-platform --agent builder --status running

  # Camp auto-write commit sessions
  obey session list --auto-commit --status running
```

### Options

```
      --active                show only active sessions (default true)
  -a, --agent string          filter by agent name
      --all                   include stopped and failed session history
      --auto-commit           filter sessions created by camp commit --auto-write
  -c, --campaign string       filter by campaign name or UUID
      --cursor string         resume from a previous list cursor
  -g, --group string          filter by group ID
  -h, --help                  help for list
      --json                  output sessions as JSON
      --limit uint32          maximum sessions to return
      --mode string           filter by execution mode
      --order-by string       sort order: attention (default: creation order)
      --parent string         filter by parent session ID
  -p, --provider string       filter by provider
      --root                  show root sessions only
      --selector string       target selector: id:<session>, agent:<name>, @<name>, or session ID/prefix
      --session stringArray   filter by exact session ID; may be repeated
  -s, --status string         filter by status
      --tui                   browse sessions interactively
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
