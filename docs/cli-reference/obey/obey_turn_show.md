---
title: "obey turn show"
linkTitle: "obey turn show"
description: "Show one durable turn"
---

## obey turn show

Show one durable turn

```
obey turn show <turn-id> [flags]
```

### Examples

```
  obey turn show TURN_ID
  obey turn show TURN_ID --json
```

### Options

```
  -c, --campaign string   campaign name or UUID
      --diagnostics       include authorized provider execution identifiers
  -h, --help              help for show
      --json              output versioned stable JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey turn](../obey_turn/)	 - Inspect and recover durable turns
