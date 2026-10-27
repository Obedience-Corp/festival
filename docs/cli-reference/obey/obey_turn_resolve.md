---
title: "obey turn resolve"
linkTitle: "obey turn resolve"
description: "Explicitly resolve a recovery-required turn"
---

## obey turn resolve

Explicitly resolve a recovery-required turn

### Synopsis

Explicitly resolve a recovery-required turn using the exact version,
attempt, and lease epoch currently stored by the daemon. Retrying creates a new
turn; it never proves the interrupted provider or tool effects did not occur.

```
obey turn resolve <turn-id> [flags]
```

### Options

```
      --acknowledge-effect-risk   confirm retry may duplicate ambiguous external effects
      --action string             resolution: cancel, mark-failed, adopt, or retry
  -c, --campaign string           campaign name or UUID
      --client-ref string         optional client correlation for a retry turn
      --content string            verified result content to append through the transcript boundary
      --error-code string         stable error code for failed outcomes
      --error-message string      operator-visible error detail
  -h, --help                      help for resolve
      --idempotency-key string    required unique key for a retry turn
      --json                      output versioned stable JSON
      --outcome string            adopted outcome: completed or failed
      --reason string             auditable operator reason (required)
      --result-ref string         external receipt ID for an adopted result
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey turn](../obey_turn/)	 - Inspect and recover durable turns
