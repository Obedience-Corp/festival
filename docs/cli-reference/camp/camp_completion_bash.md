## camp completion bash

Generate the autocompletion script for bash

### Synopsis

Generate the autocompletion script for the bash shell.

This script depends on the 'bash-completion' package.
If it is not installed already, you can install it via your OS's package manager.

To load completions in your current shell session:

	source <(camp completion bash)

To load completions for every new session, execute once:

#### Linux:

	camp completion bash > /etc/bash_completion.d/camp

#### macOS:

	camp completion bash > $(brew --prefix)/etc/bash_completion.d/camp

You will need to start a new shell for this setup to take effect.


```
camp completion bash
```

### Options

```
  -h, --help              help for bash
      --no-descriptions   disable completion descriptions
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp completion](camp_completion.md)	 - Generate the autocompletion script for the specified shell

