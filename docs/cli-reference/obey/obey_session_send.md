---
title: "obey session send"
linkTitle: "obey session send"
description: "Send a message to a session"
---

## obey session send

Send a message to a session

### Synopsis

Send a message to an Obey-owned session or a bridged session with a verified input channel.

Start an interactive provider with obey wrap and installed bridge hooks to enable
input in any terminal on Linux or macOS. Supported terminal relays also provide
input channels. Delivery is confirmed by the provider transcript.

For an external session without an input handle, the command records a durable
note labeled undelivered; it never claims the provider received the message.

```
obey session send [session-selector] <message> [flags]
```

### Options

```
  -c, --campaign string    campaign name or UUID (defaults to the campaign at the current working directory)
      --file stringArray   attach a PNG, JPEG, or PDF; may be repeated
  -h, --help               help for send
      --mode string        override the session's execution mode; the override persists on the session for subsequent sends (for example: autonomous, supervised, plan, discussion, fest)
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
