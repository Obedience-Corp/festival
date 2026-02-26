## camp flow show

Show workflow structure

### Synopsis

Display the workflow structure and configuration.

Shows the directories defined in the workflow, their descriptions,
and transition rules.

Use --schema to display the raw .workflow.yaml file.

Examples:
  camp flow show             Show workflow structure
  camp flow show --schema    Show raw schema file

```
camp flow show [flags]
```

### Options

```
  -h, --help     help for show
  -s, --schema   show raw schema file
  -t, --tree     display as tree
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

