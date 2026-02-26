## camp leverage config

View or update leverage configuration

### Synopsis

View or update leverage score configuration settings.

Without flags, displays the current configuration. With flags, updates
the configuration and saves it to .campaign/leverage/config.json.

Configuration parameters:
  --people       Number of developers on the team
  --start        Project start date (YYYY-MM-DD format)
  --cocomo-type  COCOMO project type (organic, semi-detached, embedded)
  --exclude      Exclude a project from leverage scoring
  --include      Include a previously excluded project

Examples:
  camp leverage config                         Show current config
  camp leverage config --people 3              Set team size to 3
  camp leverage config --start 2025-01-01      Set project start date
  camp leverage config --exclude obey-daemon   Exclude a project
  camp leverage config --include obey-daemon   Re-include a project

```
camp leverage config [flags]
```

### Options

```
      --author-email string   default author email for personal leverage (empty = team view)
      --cocomo-type string    COCOMO project type (organic, semi-detached, embedded)
      --exclude string        exclude a project from leverage scoring
  -h, --help                  help for config
      --include string        include a previously excluded project
      --people int            number of developers on the team (0 = auto-detect from git)
      --start string          project start date (YYYY-MM-DD)
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp leverage](camp_leverage.md)	 - Compute leverage scores for campaign projects

