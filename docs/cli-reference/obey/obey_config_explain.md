---
title: "obey config explain"
linkTitle: "obey config explain"
description: "Show each effective setting and the layer that supplied it"
---

## obey config explain

Show each effective setting and the layer that supplied it

### Synopsis

Print every local-runtime setting with the value each layer proposed and the
value in force, so "why is this number what it is" has an answer that does not
require reading the source.

The layers, most general first:

  detected      what the hardware probe found
  class table   what obey's shipped class table and formulas computed from it
  guardrail     what the guardrail level shifted that to
  environment   an environment override, where one exists for the setting
  daemon.yaml   what ~/.obey/daemon.yaml set
  effective     the value in force

Layers that supplied nothing are printed as "not set", because that is the
answer to why a config file appears to be doing nothing.

With no key, every setting is printed. With a key, only that one.

```
obey config explain [key] [flags]
```

### Options

```
  -h, --help   help for explain
      --json   emit the report as JSON
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey config](../obey_config/)	 - Inspect daemon configuration
