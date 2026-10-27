---
title: "obey completion fish"
linkTitle: "obey completion fish"
description: "Generate the autocompletion script for fish"
---

## obey completion fish

Generate the autocompletion script for fish

### Synopsis

Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	obey completion fish | source

To load completions for every new session, execute once:

	obey completion fish > ~/.config/fish/completions/obey.fish

You will need to start a new shell for this setup to take effect.


```
obey completion fish [flags]
```

### Options

```
  -h, --help              help for fish
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --no-color        disable colored output
      --socket string   override resolved socket path (default: from config or ~/.local/share/obey/daemon.sock)
      --theme string    color theme: adaptive, light, dark, high-contrast (default "adaptive")
```

### SEE ALSO

* [obey completion](../obey_completion/)	 - Generate the autocompletion script for the specified shell
