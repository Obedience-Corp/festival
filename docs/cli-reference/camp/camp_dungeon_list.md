## camp dungeon list

List dungeon items

### Synopsis

List items in the dungeon or parent items eligible for triage.

By default, lists items at the dungeon root (items already in the dungeon).
Use --triage to list parent directory items that could be moved into the dungeon.
The command resolves dungeon context by walking from the current directory up to
campaign root and using the nearest available dungeon.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            Names only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp dungeon list                  List dungeon root items
  camp dungeon list --triage         List parent items eligible for triage
  cd workflow/design/subdir && camp dungeon list  Uses nearest dungeon context from nested path
  camp dungeon list -f json          JSON output for scripting
  camp dungeon list -f simple        Names only, pipe to other commands

```
camp dungeon list [flags]
```

### Options

```
  -f, --format string   Output format: table, simple, json (default "table")
  -h, --help            help for list
      --triage          List parent items eligible for triage into dungeon
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp dungeon](camp_dungeon.md)	 - Manage the campaign dungeon

