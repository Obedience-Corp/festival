---
title: "obey session"
linkTitle: "obey session"
description: "Manage agent sessions"
---

## obey session

Manage agent sessions

### Synopsis

Create, monitor, and control AI agent sessions running in the daemon.

### Options

```
  -h, --help   help for session
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey session abandon](../obey_session_abandon/)	 - Mark an unaccounted-for session abandoned
* [obey session abandoned](../obey_session_abandoned/)	 - List bridged sessions that have gone quiet past the abandon horizon
* [obey session approvals](../obey_session_approvals/)	 - List pending supervised tool approvals
* [obey session approve](../obey_session_approve/)	 - Approve or deny a pending supervised tool call
* [obey session archive](../obey_session_archive/)	 - Soft-hide one session from default lists
* [obey session attach](../obey_session_attach/)	 - Attach to a live session stream
* [obey session chain](../obey_session_chain/)	 - Manage watch chains between sessions
* [obey session children](../obey_session_children/)	 - List direct children of a session
* [obey session compact](../obey_session_compact/)	 - Ask a session to compact its in-flight context
* [obey session create](../obey_session_create/)	 - Create a new agent session
* [obey session detach](../obey_session_detach/)	 - Detach a session from its parent
* [obey session dismiss](../obey_session_dismiss/)	 - Stop one session from drawing attention
* [obey session events](../obey_session_events/)	 - Show stored session events
* [obey session group](../obey_session_group/)	 - Manage session groups
* [obey session info](../obey_session_info/)	 - Show detailed session information
* [obey session last](../obey_session_last/)	 - Show the most recently active sessions, across all statuses
* [obey session list](../obey_session_list/)	 - List agent sessions
* [obey session modes](../obey_session_modes/)	 - List execution modes for sessions
* [obey session notify](../obey_session_notify/)	 - Deliver a durable one-shot notification to a session
* [obey session queue](../obey_session_queue/)	 - Sessions ordered by which ones need you, without a terminal
* [obey session rename](../obey_session_rename/)	 - Change a session's display name
* [obey session reopen](../obey_session_reopen/)	 - Let one dismissed session draw attention again
* [obey session respin](../obey_session_respin/)	 - Bring back the sessions that were live when the daemon last went down
* [obey session restart](../obey_session_restart/)	 - Restart a stopped or failed session
* [obey session run](../obey_session_run/)	 - Create a session and run one operator prompt
* [obey session send](../obey_session_send/)	 - Send a message to a session
* [obey session set-disposition](../obey_session_set-disposition/)	 - Change whether a session is brought back after a crash
* [obey session stats](../obey_session_stats/)	 - Show detailed per-session metrics
* [obey session stop](../obey_session_stop/)	 - Stop a running session
* [obey session switch](../obey_session_switch/)	 - Move a session to a different provider or model, keeping its identity
* [obey session transcript](../obey_session_transcript/)	 - Show a stored session transcript
* [obey session tree](../obey_session_tree/)	 - Display session hierarchy as a tree
* [obey session turns](../obey_session_turns/)	 - List durable turns for a session
* [obey session unarchive](../obey_session_unarchive/)	 - Show one archived session in default lists
* [obey session use](../obey_session_use/)	 - Set the current session for a campaign
* [obey session watch](../obey_session_watch/)	 - Watch session status changes
