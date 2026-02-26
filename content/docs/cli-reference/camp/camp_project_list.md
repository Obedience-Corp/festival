## camp project list

List projects in campaign

### Synopsis

List all projects in the current campaign.

Projects are git repositories located in the projects/ directory.
The command detects project types by looking for marker files like
go.mod (Go), Cargo.toml (Rust), or package.json (TypeScript).

Output formats:
  table   - Aligned columns with headers (default)
  simple  - Project names only, one per line
  json    - JSON array for scripting

Examples:
  camp project list               List projects in table format
  camp project list --format json Output as JSON
  camp project list --format simple  Names only for scripting

```
camp project list [flags]
```

### Options

```
  -f, --format string   Output format (table, simple, json) (default "table")
  -h, --help            help for list
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp project](camp_project.md)	 - Manage campaign projects

