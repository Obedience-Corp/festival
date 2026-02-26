## camp flow add

Add workflow tracking to current directory

### Synopsis

Add workflow tracking to the current directory.

Creates a .workflow.yaml file, dungeon/ directory structure, and root OBEY.md.
Uses workflow schema v2 (dungeon-centric model) where:
  - Root directory (.) = active work
  - dungeon/           = all other statuses

If dungeon/ already exists, only creates .workflow.yaml.
If both exist, displays a notice.

Use --force to overwrite an existing workflow configuration.

Provide name/description via flags, JSON, or interactive TUI:
  --name/-n and --description/-d   Set via flags
  --json/-j '{"name":"...","description":"..."}'  Set via JSON
  --json -   Read JSON from stdin (for piping)

Note: Flows cannot be nested inside other flows. If you're inside a flow,
navigate to a directory outside of it before running this command.

Examples:
  camp flow add                                      Interactive TUI
  camp flow add --name "API" --description "API dev" Via flags
  camp flow add --json '{"name":"API","description":"API development"}'
  echo '{"name":"X","description":"Y"}' | camp flow add --json -
  camp flow add --force                              Overwrite existing

```
camp flow add [flags]
```

### Options

```
  -d, --description string   workflow description/purpose
  -f, --force                overwrite existing workflow
  -h, --help                 help for add
  -j, --json string          JSON input (use "-" for stdin)
  -n, --name string          workflow name
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.obey/campaign/config.yaml)
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [camp flow](camp_flow.md)	 - Manage status workflows for organizing work

