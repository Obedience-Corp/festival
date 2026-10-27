---
title: "obey completion zsh"
linkTitle: "obey completion zsh"
description: "Generate the autocompletion script for zsh"
---

## obey completion zsh

Generate the autocompletion script for zsh

### Synopsis

Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(obey completion zsh)

To load completions for every new session, execute once:

#### Linux:

	obey completion zsh > "${fpath[1]}/_obey"

#### macOS:

	obey completion zsh > $(brew --prefix)/share/zsh/site-functions/_obey

You will need to start a new shell for this setup to take effect.


```
obey completion zsh [flags]
```

### Options

```
  -h, --help              help for zsh
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
