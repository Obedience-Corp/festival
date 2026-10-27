---
title: "obey session switch"
linkTitle: "obey session switch"
description: "Move a session to a different provider or model, keeping its identity"
---

## obey session switch

Move a session to a different provider or model, keeping its identity

### Synopsis

Point an existing session at a different provider or model.

The session id does not change. What crosses the provider boundary is TEXT:
obey stops the current adapter and hands the new one the conversation so far as
an opening context message. There is no protocol for transferring a provider's
conversation to a different provider, and this command does not pretend
otherwise.

The previous conversation id is recorded in the session's provider history, so
the earlier conversation stays resumable and nothing is lost.

--compact hands over a shortened conversation instead of the full one. It is
refused, not quietly ignored, when the current provider cannot compact.

--reasoning-effort sets the effort the new conversation runs at. It is written
into the session's stored config as obey.reasoning_effort, keeping every other
option, and may be the only thing a switch changes. The adapter restarts and
receives the conversation as it would for a provider change, because CLI
providers read their effort once, at start.

Bridged sessions are refused: obey did not start them and cannot restart them
under a different provider.

```
obey session switch <session-selector> [flags]
```

### Examples

```
  # Move a session to a different provider
  obey session switch 7fcde681 --provider openai --model gpt-5.4

  # Change model only
  obey session switch 7fcde681 --model gpt-5.4

  # Hand over a shortened conversation
  obey session switch 7fcde681 --provider openai --compact

  # Change only the reasoning effort
  obey session switch 7fcde681 --reasoning-effort high
```

### Options

```
  -c, --campaign string           campaign name or UUID
      --compact                   hand over a compacted conversation instead of the full one
  -h, --help                      help for switch
      --json                      output the result as JSON
      --model string              target model (omit to use the provider's default; an effort-only switch keeps the current model)
      --provider string           target provider (omit to keep the current one)
      --reasoning-effort string   reasoning effort for the new conversation (stored as obey.reasoning_effort; the rest of the session config is kept): none, low, medium, high, xhigh, or max; refused for providers that cannot apply it
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey session](../obey_session/)	 - Manage agent sessions
