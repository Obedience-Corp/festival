## camp flow items

List items in a status directory

### Synopsis

List items in a status directory.

If no status is specified, lists items in the default status (usually 'active').
Use --all to list items in all status directories.

Examples:
  camp flow items              List items in default status
  camp flow items active       List items in active/
  camp flow items dungeon/completed  List items in dungeon/completed/
  camp flow items --all        List items in all statuses

```
camp flow items [status] [flags]
```

### Options

```
  -a, --all    list all statuses
  -h, --help   help for items
      --json   output as JSON
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

