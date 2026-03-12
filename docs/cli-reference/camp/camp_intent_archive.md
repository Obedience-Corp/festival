## camp intent archive

Archive an intent

### Synopsis

Archive an intent by moving it to dungeon/archived.

This is a convenience command equivalent to:
  camp intent move <id> archived --reason "..."

Dungeon moves require a reason and append a decision record to the intent body.
Use 'camp intent move <id> inbox' to un-archive if needed.

Examples:
  camp intent archive add-dark --reason "superseded by broader initiative"
  camp intent archive 20260119-153412 --reason "preserve as reference"

```
camp intent archive <id> [flags]
```

### Options

```
  -h, --help            help for archive
      --no-commit       Don't create a git commit
      --reason string   Reason for archiving (required)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp intent](camp_intent.md)	 - Manage campaign intents

