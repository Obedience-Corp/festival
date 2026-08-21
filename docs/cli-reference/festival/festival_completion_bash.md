---
title: "festival completion bash"
linkTitle: "festival completion bash"
description: "Generate the autocompletion script for bash"
---

## festival completion bash

Generate the autocompletion script for bash

### Synopsis

Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(festival completion bash)

To load completions for every new session, execute once:

#### Linux:

	festival completion bash > /etc/bash_completion.d/festival

#### macOS:

	festival completion bash > $(brew --prefix)/etc/bash_completion.d/festival

You will need to start a new shell for this setup to take effect.


```
festival completion bash
```

### Options

```
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

### SEE ALSO

* [festival completion](../festival_completion/)	 - Generate the autocompletion script for the specified shell
