---
title: "obey providers"
linkTitle: "obey providers"
description: "List configured providers"
---

## obey providers

List configured providers

### Synopsis

List providers from local daemon config or a running daemon.

Without --socket, reads ~/.obey/daemon.yaml (or OBEY_CONFIG) directly and
reports every available provider: the built-in CLI-backed providers
(claude-code, codex, cursor, fx, grok) that work whenever their binary is on PATH,
local Ollama at http://127.0.0.1:11434, plus any provider entries declared in
config. Each line shows whether the provider is supported and minimally
configured in this obey build. A decision provider (type: typesafe) is labeled
as one and checked with a live model listing; it never runs sessions.

With --socket, queries the running daemon via the ListProviders RPC and reports
each session provider's enabled state, default model, and which profile is the
daemon-owned global default for new sessions.

The global default is owned by the daemon (SetDefaultProvider). Use
"obey providers set-default" with --socket to change it. Chat clients must not
invent their own defaults.

```
obey providers [flags]
```

### Options

```
  -h, --help   help for providers
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey providers set-default](../obey_providers_set-default/)	 - Set the daemon-owned default provider for new sessions
* [obey providers status](../obey_providers_status/)	 - Show what local inference is holding on this node
