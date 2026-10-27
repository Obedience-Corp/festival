---
title: "obey session create"
linkTitle: "obey session create"
description: "Create a new agent session"
---

## obey session create

Create a new agent session

### Synopsis

Create a new agent session managed by the daemon.

By default the session is provider-backed: the daemon launches the configured
provider/model process. Use --external to register an external agent session
instead. External sessions are tracked for their lifecycle (created, running,
stopped) and event history but the daemon does not launch a model process and
does not deliver messages to them, so they are safe for auditing and integration
testing. session send records a durable note labeled undelivered; it does not
inject input or promise that the external provider will see it.

```
obey session create [flags]
```

### Examples

```
  # Provider-backed session
  obey session create --provider claude-code --model sonnet --agent builder

  # External session (no model process; safe for testing)
  obey session create --external --provider external --model cli-audit \
    --agent audit --mode discussion
```

### Options

```
  -a, --agent string              agent name
      --agent-profile string      operator-owned authority profile for the session
  -c, --campaign string           campaign name or UUID (defaults to the campaign at the current working directory)
      --config string             session config (JSON string)
      --external                  register an external agent session (no model process launched; safe for testing)
      --festival string           festival ID
  -h, --help                      help for create
      --mode string               initial execution mode (for example: autonomous, supervised, plan, discussion, fest)
  -m, --model string              model name (required)
  -p, --provider string           AI provider (required)
      --reasoning-effort string   reasoning effort (stored as obey.reasoning_effort): none, low, medium, high, xhigh, or max; refused for providers that cannot apply it
      --task string               task ID
  -w, --workdir string            working directory
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
