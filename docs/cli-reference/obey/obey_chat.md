---
title: "obey chat"
linkTitle: "obey chat"
description: "Interactive chat attached to an agent session"
---

## obey chat

Interactive chat attached to an agent session

### Synopsis

Conversation-first view of one agent session: transcript backfill, live streaming, sends, and inline approvals. Without a selector it uses the campaign's current session (obey session use) or the only active session.

```
obey chat [session-selector] [flags]
```

### Examples

```
  obey chat
  obey chat @builder
  obey chat 09c227db-1a2b
```

### Options

```
  -c, --campaign string   campaign name or UUID (defaults to current directory's campaign)
  -h, --help              help for chat
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
