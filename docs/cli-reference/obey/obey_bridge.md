---
title: "obey bridge"
linkTitle: "obey bridge"
description: "Bridge external terminal sessions into obey"
---

## obey bridge

Bridge external terminal sessions into obey

### Synopsis

Bridge external terminal sessions into obey.

Bridge commands are intended for fail-open Claude Code, Codex, and Grok hooks,
plus other local integrations that report externally managed terminal sessions to the daemon.
When a bridge registration omits --campaign, the daemon stores the session in
the __unassigned__ bucket so it remains observable without appearing in campaign-scoped
session lists.

### Options

```
      --debug   print bridge hook diagnostics instead of staying silent
  -h, --help    help for bridge
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey bridge activity](../obey_bridge_activity/)	 - Record coarse activity for a bridged external session
* [obey bridge dispatch](../obey_bridge_dispatch/)	 - Route a provider's native hook event to the matching bridge verb
* [obey bridge doctor](../obey_bridge_doctor/)	 - Diagnose installed bridge hooks
* [obey bridge end](../obey_bridge_end/)	 - Mark a bridged external session ended
* [obey bridge heartbeat](../obey_bridge_heartbeat/)	 - Record liveness for a bridged external session
* [obey bridge install](../obey_bridge_install/)	 - Install obey's bridge hook for a provider
* [obey bridge profiles](../obey_bridge_profiles/)	 - List bridge provider profiles
* [obey bridge reconcile](../obey_bridge_reconcile/)	 - Discover and register already-running provider sessions
* [obey bridge register](../obey_bridge_register/)	 - Register an externally managed provider session
* [obey bridge relay](../obey_bridge_relay/)	 - Serve input for one bridged session's Ghostty terminal (macOS)
* [obey bridge status](../obey_bridge_status/)	 - Show bridge hook status per provider
* [obey bridge uninstall](../obey_bridge_uninstall/)	 - Remove obey-owned bridge hooks without touching foreign configuration
