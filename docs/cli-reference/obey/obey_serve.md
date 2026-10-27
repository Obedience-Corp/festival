---
title: "obey serve"
linkTitle: "obey serve"
description: "Start the daemon"
---

## obey serve

Start the daemon

### Synopsis

Start the daemon, which monitors campaigns and festivals.

```
obey serve [flags]
```

### Options

```
  -c, --config string       config file (default ~/.obey/daemon.yaml)
  -d, --data-dir string     data directory (overrides config)
      --foreground          run in foreground (attached to terminal)
  -h, --help                help for serve
  -u, --hub string          hub URL (overrides config)
  -l, --log-level string    log level: debug, info, warn, error
      --no-firewall-setup   skip one-time Linux firewall authorization (remote access may be blocked)
      --no-grpc             disable gRPC server
      --no-network          disable the LAN/Tailscale listeners, discovery, and the hub connection
      --no-watcher          disable file watcher
  -s, --socket string       gRPC socket path (overrides config)
      --tcp-listen string   optional explicit TCP gRPC listen address (for SSH, LAN, or Tailscale access)
```

### Options inherited from parent commands

```
      --no-color       disable colored output
      --theme string   color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
