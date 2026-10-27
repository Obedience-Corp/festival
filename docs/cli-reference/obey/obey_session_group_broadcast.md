---
title: "obey session group broadcast"
linkTitle: "obey session group broadcast"
description: "Broadcast a message to active group members"
---

## obey session group broadcast

Broadcast a message to active group members

```
obey session group broadcast <group-id> <message> [flags]
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to the campaign at the current working directory)
  -h, --help              help for broadcast
      --sender string     optional sender session selector: id:<session>, agent:<name>, @<name>, or session ID/prefix
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session group](../obey_session_group/)	 - Manage session groups
