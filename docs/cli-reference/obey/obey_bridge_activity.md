---
title: "obey bridge activity"
linkTitle: "obey bridge activity"
description: "Record coarse activity for a bridged external session"
---

## obey bridge activity

Record coarse activity for a bridged external session

```
obey bridge activity [flags]
```

### Options

```
      --arguments string    tool call arguments
      --call-id string      tool call id
      --campaign string     campaign name or UUID; defaults to bridge state, cwd inference, then unassigned
      --cwd string          working directory for campaign inference
      --error string        activity error text
  -h, --help                help for activity
      --result string       tool result text
      --session-id string   provider-native hook/session id or daemon session id
      --success             whether a tool result succeeded (default true)
      --summary string      activity summary
      --tool string         tool name for tool activity
      --type string         activity type: tool_call, tool_result, completion (default "completion")
```

### Options inherited from parent commands

```
      --debug           print bridge hook diagnostics instead of staying silent
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey bridge](../obey_bridge/)	 - Bridge external terminal sessions into obey
