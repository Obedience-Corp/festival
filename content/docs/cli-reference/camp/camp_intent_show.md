## camp intent show

Show detailed intent information

### Synopsis

Display detailed information about a specific intent.

Supports partial ID matching - you can use:
  - Full ID: 20260119-153412-add-retry-logic
  - Time suffix: 153412-add-retry
  - Slug portion: add-retry

OUTPUT FORMATS:
  text (default)   Human-readable detailed view
  json             Full metadata in JSON format
  yaml             Full metadata in YAML format

Examples:
  camp intent show 20260119-153412...    Show by full ID
  camp intent show retry-logic           Show by partial match
  camp intent show retry -f json         JSON output
  camp intent show retry -f yaml         YAML output

```
camp intent show <id> [flags]
```

### Options

```
  -f, --format string   Output format: text, json, yaml (default "text")
  -h, --help            help for show
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

