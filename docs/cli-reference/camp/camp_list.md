## camp list

List all registered campaigns

### Synopsis

List all campaigns registered in the global registry.

Campaigns are registered when created with 'camp init' or manually
with 'camp register'. The registry lives at ~/.obey/campaign/registry.yaml.

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Campaign names only, one per line
  json    - JSON array for scripting

Sorting options:
  accessed - Most recently accessed first (default)
  name     - Alphabetically by name
  type     - Alphabetically by type

Examples:
  camp list                  List all campaigns
  camp list --format json    Output as JSON
  camp list --sort name      Sort by name
  camp list --format simple  Names only for scripting

```
camp list [flags]
```

### Options

```
  -f, --format string    Output format (table, simple, json) (default "table")
  -h, --help             help for list
  -s, --sort string      Sort by (name, accessed, type) (default "accessed")
      --verify-verbose   Show detailed verification output
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp](camp.md)	 - Campaign management CLI for multi-project AI workspaces

