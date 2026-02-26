## camp intent edit

Edit an existing intent

### Synopsis

Edit an intent in your preferred editor.

If ID is provided, opens the intent directly (supports partial matching).
If no ID is provided, shows a fuzzy picker to select an intent.

PARTIAL ID MATCHING:
  Full ID:       20260119-153412-add-retry-logic
  Time suffix:   153412-add-retry
  Slug portion:  add-retry

Examples:
  camp intent edit                       Interactive picker
  camp intent edit 20260119-153412...    Direct edit by full ID
  camp intent edit retry-logic           Partial match edit
  camp intent edit --status active       Picker filtered by status

```
camp intent edit [id] [flags]
```

### Options

```
  -h, --help             help for edit
  -p, --project string   Filter picker by project
  -s, --status string    Filter picker by status
  -t, --type string      Filter picker by type
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

