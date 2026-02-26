## camp flow run

Execute a registered flow by name

### Synopsis

Execute a registered flow from .campaign/flows/registry.yaml.

Extra arguments after -- are appended to the flow's command.

Examples:
  camp flow run build
  camp flow run test -- --verbose
  camp flow run deploy -- production

```
camp flow run <name> [-- extra-args...] [flags]
```

### Options

```
  -h, --help   help for run
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

