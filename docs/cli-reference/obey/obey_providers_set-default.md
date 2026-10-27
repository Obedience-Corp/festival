---
title: "obey providers set-default"
linkTitle: "obey providers set-default"
description: "Set the daemon-owned default provider for new sessions"
---

## obey providers set-default

Set the daemon-owned default provider for new sessions

### Synopsis

Mark a provider profile as the global default used when clients create a
new session without an explicit provider.

Requires a running daemon (--socket). Persists default_provider (and optional
default_model) in the daemon config. PATH-seeded CLI agents without a yaml row
are materialized as durable profiles when selected.

```
obey providers set-default <provider> [flags]
```

### Options

```
  -h, --help           help for set-default
      --model string   optional default model for the provider
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey providers](../obey_providers/)	 - List configured providers
