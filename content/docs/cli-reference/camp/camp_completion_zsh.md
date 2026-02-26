## camp completion zsh

Generate the autocompletion script for zsh

### Synopsis

Generate the autocompletion script for the zsh shell.

If shell completion is not already enabled in your environment you will need
to enable it.  You can execute the following once:

	echo "autoload -U compinit; compinit" >> ~/.zshrc

To load completions in your current shell session:

	source <(camp completion zsh)

To load completions for every new session, execute once:

#### Linux:

	camp completion zsh > "${fpath[1]}/_camp"

#### macOS:

	camp completion zsh > $(brew --prefix)/share/zsh/site-functions/_camp

You will need to start a new shell for this setup to take effect.


```
camp completion zsh [flags]
```

### Options

```
  -h, --help              help for zsh
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

