---
title: "obey models"
linkTitle: "obey models"
description: "Inspect the models this node can run"
---

## obey models

Inspect the models this node can run

### Synopsis

Report what the models installed on this node's local runtime would cost and
whether they belong here.

This is read-only. It never warms a model, releases one, or downloads one.

### Options

```
  -h, --help   help for models
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey](../obey/)	 - CLI for managing your agentic organization
* [obey models fits](../obey_models_fits/)	 - Show which installed models fit on this node, and how well
