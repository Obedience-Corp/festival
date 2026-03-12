## camp intent count

Count intents by status directory

### Synopsis

Display a count of intents grouped by status directory.

OUTPUT FORMATS:
  table (default)   Styled summary with counts per status
  json              Machine-readable JSON output

Examples:
  camp intent count              Show counts per status
  camp intent count -f json      JSON output for scripting

```
camp intent count [flags]
```

### Options

```
  -f, --format string   Output format: table, json (default "table")
  -h, --help            help for count
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

