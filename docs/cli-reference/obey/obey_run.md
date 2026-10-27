---
title: "obey run"
linkTitle: "obey run"
description: "Create a session and run one operator prompt"
---

## obey run

Create a session and run one operator prompt

### Synopsis

Create a daemon-backed agent session, send one prompt, and stream the resulting activity.

```
obey run [flags] [message]
```

### Options

```
  -a, --agent string              agent name
      --agent-profile string      operator-owned authority profile for the session
  -c, --campaign string           campaign name or UUID (defaults to the campaign at the current working directory)
      --config string             session config (JSON string)
      --festival string           festival ID
      --file stringArray          attach a PNG, JPEG, or PDF; may be repeated
  -h, --help                      help for run
      --input string              read the operator prompt from input source ('-' for stdin; requires --json)
      --json                      emit the obey.session.run/v1 NDJSON stream (requires --input -)
      --mode string               initial execution mode and send-mode override
  -m, --model string              model name (required)
  -p, --provider string           AI provider (required)
      --reasoning-effort string   reasoning effort (stored as obey.reasoning_effort): none, low, medium, high, xhigh, or max; refused for providers that cannot apply it
      --task string               task ID
      --timeout duration          machine-mode wall-clock limit for the run (0 disables; ignored without --json) (default 30m0s)
  -w, --workdir string            working directory
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
