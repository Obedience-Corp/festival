## camp intent archive

Archive an intent

### Synopsis

Archive an intent by moving it to the killed status.

This is a convenience command equivalent to:
  camp intent move <id> killed

Archived intents are retained but hidden from default listings.
Use 'camp intent move <id> inbox' to un-archive if needed.

Examples:
  camp intent archive add-dark           Archive by partial ID
  camp intent archive 20260119-153412    Archive by full ID

```
camp intent archive <id> [flags]
```

### Options

```
  -h, --help        help for archive
      --no-commit   Don't create a git commit
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

