## camp register

Register campaign in global registry

### Synopsis

Register an existing campaign in the global registry.

This adds the campaign to the registry at ~/.obey/campaign/registry.yaml,
enabling it to appear in 'camp list' and be accessible via navigation commands.

Note: 'camp init' automatically registers new campaigns. This command is for
registering existing campaigns that weren't created with camp or were unregistered.

If the specified path is not a campaign (has no .campaign/ directory),
you'll be offered the option to initialize it.

Examples:
  camp register                          # Register current directory
  camp register ~/Dev/my-project         # Register specified path
  camp register . --name custom-name     # Override the campaign name
  camp register . --type research        # Override the campaign type

```
camp register [path] [flags]
```

### Options

```
  -h, --help          help for register
  -n, --name string   Override campaign name
  -t, --type string   Override campaign type (product, research, tools, personal)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

