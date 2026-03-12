## camp intent list

List intents in the campaign

### Synopsis

List intents with filtering, sorting, and output format options.

By default, lists intents in inbox, active, and ready status.
Use --all to include dungeon intents.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            IDs only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp intent list                         List active intents
  camp intent ls --status inbox            List inbox only
  camp intent list -f json                 JSON output
  camp intent list -f simple | xargs ...   Pipe IDs to commands
  camp intent list --all                   Include archived

```
camp intent list [flags]
```

### Options

```
  -a, --all              Include dungeon intents
  -f, --format string    Output format: table, simple, json (default "table")
  -h, --help             help for list
      --horizon string   Filter by horizon
  -n, --limit int        Limit results (0 = no limit)
  -p, --project string   Filter by project
  -S, --sort string      Sort by: updated, created, priority, title (default "updated")
  -s, --status strings   Filter by status (repeatable)
  -t, --type strings     Filter by type (repeatable)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

