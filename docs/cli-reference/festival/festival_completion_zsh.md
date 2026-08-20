---
title: "festival completion zsh"
linkTitle: "festival completion zsh"
description: "Generate the autocompletion script for zsh"
---

## festival completion zsh

Generate the autocompletion script for zsh

### Synopsis

Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(festival completion zsh)

To load completions for every new session, execute once:

#### Linux:

	festival completion zsh > "${fpath[1]}/_festival"

#### macOS:

	festival completion zsh > $(brew --prefix)/share/zsh/site-functions/_festival

You will need to start a new shell for this setup to take effect.


```
festival completion zsh [flags]
```

### Options

```
  -h, --help              help for zsh
      --no-descriptions   disable completion descriptions
```

### SEE ALSO

* [festival completion](../festival_completion/)	 - Generate the autocompletion script for the specified shell
