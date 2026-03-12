## camp completion fish

Generate the autocompletion script for fish

### Synopsis

Generate the autocompletion script for the fish shell.

To load completions in your current shell session:

	camp completion fish | source

To load completions for every new session, execute once:

	camp completion fish > ~/.config/fish/completions/camp.fish

You will need to start a new shell for this setup to take effect.


```
camp completion fish [flags]
```

### Options

```
  -h, --help              help for fish
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

