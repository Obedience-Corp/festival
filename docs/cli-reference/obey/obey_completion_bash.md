---
title: "obey completion bash"
linkTitle: "obey completion bash"
description: "Generate the autocompletion script for bash"
---

## obey completion bash

Generate the autocompletion script for bash

### Synopsis

Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(obey completion bash)

To load completions for every new session, execute once:

#### Linux:

	obey completion bash > /etc/bash_completion.d/obey

#### macOS:

	obey completion bash > $(brew --prefix)/etc/bash_completion.d/obey

You will need to start a new shell for this setup to take effect.


```
obey completion bash
```

### Options

```
  -h, --help              help for bash
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
