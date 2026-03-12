## camp intent find

Search for intents by title or content

### Synopsis

Search for intents across all statuses by title, content, or ID.

The search is case-insensitive and matches partial strings.
Without a query, returns all intents.

OUTPUT FORMATS:
  table (default)   Human-readable table with columns
  simple            IDs only, one per line (for scripting)
  json              Full metadata in JSON format

Examples:
  camp intent find                   List all intents
  camp intent find dark              Find intents containing "dark"
  camp intent find "bug fix"         Find intents with "bug fix"
  camp intent find -f simple auth    Get IDs of auth-related intents

```
camp intent find [query] [flags]
```

### Options

```
  -f, --format string   Output format: table, simple, json (default "table")
  -h, --help            help for find
  -n, --limit int       Limit results (0 = no limit)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

