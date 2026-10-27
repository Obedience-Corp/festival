---
title: "obey session group"
linkTitle: "obey session group"
description: "Manage session groups"
---

## obey session group

Manage session groups

### Synopsis

Manage session groups.

A group is created active, gains and loses members with 'group add' and
'group remove', and moves to a terminal COMPLETED state after 'group stop'.
Groups are not hard-deleted; COMPLETED is the terminal state and a stopped group
remains visible in 'group list' for auditability.

'group broadcast' delivers only to provider-backed members; external sessions
cannot receive messages and are reported as failed deliveries.

### Options

```
  -h, --help   help for group
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
* [obey session group add](../obey_session_group_add/)	 - Add a session to a group
* [obey session group broadcast](../obey_session_group_broadcast/)	 - Broadcast a message to active group members
* [obey session group create](../obey_session_group_create/)	 - Create a session group
* [obey session group info](../obey_session_group_info/)	 - Show session group details and members
* [obey session group list](../obey_session_group_list/)	 - List session groups
* [obey session group remove](../obey_session_group_remove/)	 - Remove a session from a group
* [obey session group stop](../obey_session_group_stop/)	 - Stop all sessions in a group
