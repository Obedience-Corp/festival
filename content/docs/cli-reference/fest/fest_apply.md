## fest apply

Apply a local template to a destination file (copy or render)

### Synopsis

Apply a local template (from .festival/templates) to a destination file. Copy if no variables provided; render if variables exist.

```
fest apply [flags]
```

### Options

```
  -h, --help                   help for apply
      --json                   Emit JSON output
      --template-id string     Template ID or alias (from frontmatter)
      --template-path string   Path to template file (relative to .festival/templates or absolute)
      --to string              Destination file path (required)
      --vars-file string       JSON file providing variables for rendering
```

### Options inherited from parent commands

```
      --config string   config file (default: ~/.config/fest/config.json)
      --debug           enable debug logging
      --no-color        disable colored output
      --verbose         enable verbose output
```

### SEE ALSO

* [fest](fest.md)	 - Festival Methodology CLI - goal-oriented project management for AI agents

